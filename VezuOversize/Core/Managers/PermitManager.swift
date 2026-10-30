import Foundation
import SwiftData

@Observable
final class PermitManager {
    private(set) var records: [PermitRecord] = []

    private let context: ModelContext
    private let fileService: PermitFileServicable
    private let permitService: PermitServicable
    private let geocodingService: RouteGeocodingServicable
    private let junctionService: RouteJunctionServicable
    private let daysKeptAfterExpiry = 30

    init(context: ModelContext,
         fileService: PermitFileServicable = PermitFileService(),
         permitService: PermitServicable = PermitService(),
         geocodingService: RouteGeocodingServicable = RouteGeocodingService(),
         junctionService: RouteJunctionServicable = RouteJunctionService()) {
        self.context = context
        self.fileService = fileService
        self.permitService = permitService
        self.geocodingService = geocodingService
        self.junctionService = junctionService
        reload()
        deleteOldExpiredPermits()
    }

    func deleteOldExpiredPermits(now: Date = .now) {
        let calendar = Calendar.current
        let old = records.filter { record in
            guard let brief = record.brief,
                  let endOfLastDay = calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: calendar.startOfDay(for: brief.validTo)),
                  let keepUntil = calendar.date(
                    byAdding: .day,
                    value: daysKeptAfterExpiry,
                    to: max(endOfLastDay, record.createdAt)) else { return false }
            return now > keepUntil
        }
        guard !old.isEmpty else { return }

        let fileNames = old.flatMap(fileNames)
        old.forEach(context.delete)
        guard (try? context.save()) != nil else { return }
        fileNames.forEach(fileService.delete)
        reload()
    }

    func add(_ brief: PermitBrief,
             translation: PermitBriefTranslation?,
             id: UUID,
             pdfFileNames: [String],
             replacing replacedID: UUID? = nil) throws {
        let duplicates = records.filter { record in
            record.id == replacedID || (record.brief.map { isSamePermit($0, brief) } ?? false)
        }
        let replacedFileNames = duplicates.flatMap(fileNames).filter { !pdfFileNames.contains($0) }
        duplicates.forEach(context.delete)

        context.insert(try PermitRecord(id: id, pdfFileNames: pdfFileNames, brief: brief, translation: translation))
        try context.save()
        replacedFileNames.forEach(fileService.delete)
        reload()
    }

    func delete(id: UUID) throws {
        guard let record = records.first(where: { $0.id == id }) else { return }
        let fileNames = fileNames(of: record)

        context.delete(record)
        try context.save()
        fileNames.forEach(fileService.delete)
        reload()
    }

    func brief(for id: UUID) -> PermitBrief? {
        records.first { $0.id == id }?.brief
    }

    func contains(_ brief: PermitBrief) -> Bool {
        record(for: brief) != nil
    }

    func recordID(for brief: PermitBrief) -> UUID? {
        record(for: brief)?.id
    }

    func savedFileNames(for brief: PermitBrief) -> [String] {
        guard let record = record(for: brief) else { return [] }
        return fileNames(of: record).filter { fileName in
            guard let url = try? fileService.url(for: fileName) else { return false }
            return FileManager.default.fileExists(atPath: url.path(percentEncoded: false))
        }
    }

    func fileURLs(for brief: PermitBrief) -> [URL] {
        savedFileNames(for: brief).compactMap { try? fileService.url(for: $0) }
    }

    func detailedRoute(for brief: PermitBrief) async throws -> PermitDetailedRoute {
        guard let record = record(for: brief) else { throw AppError.unreadableFile }
        if let saved = record.detailedRoute {
            return saved.localized
        }

        let fileNames = savedFileNames(for: brief)
        guard !fileNames.isEmpty else { throw AppError.unreadableFile }
        let files = try fileNames.enumerated().map { index, fileName in
            let name = index == 0
                ? AppText.PermitImport.permitFileName
                : AppText.PermitImport.attachmentFileName(index)
            return PermitFile(name: name, base64: try fileService.data(for: fileName).base64EncodedString())
        }

        let response = try await permitService.detailedRoute(files)
        let summary = response.route
        let route = PermitRoute(
            origin: summary.origin.nilIfEmpty ?? brief.route.origin,
            destination: summary.destination.nilIfEmpty ?? brief.route.destination,
            totalMiles: summary.totalMiles > 0 ? summary.totalMiles : brief.route.totalMiles,
            prohibitedRoads: brief.route.prohibitedRoads,
            steps: summary.steps.map {
                PermitRouteStep(road: $0.road, instruction: $0.instruction, miles: $0.miles, isToll: $0.isToll)
            })
        let queries = queries(for: route, summary: summary)
        let found = await geocodingService.waypoints(for: queries, in: brief.stateCode.nilIfEmpty)
        let waypoints = await junctionService.shifted(found, queries: queries)
        let detailedRoute = PermitDetailedRoute(route: route, waypoints: waypoints, translation: response.translation)

        if let current = self.record(for: brief) {
            current.detailedRouteData = try JSONEncoder().encode(detailedRoute)
            try context.save()
        }
        return detailedRoute.localized
    }

    func delete(_ brief: PermitBrief) throws {
        guard let record = record(for: brief) else { return }
        try delete(id: record.id)
    }

    private func record(for brief: PermitBrief) -> PermitRecord? {
        records.first { $0.brief?.id == brief.id }
    }

    private func directionAfter(_ index: Int, in steps: [PermitDetailedRouteStepSummary]) -> String? {
        var leg: [PermitDetailedRouteStepSummary] = []
        for step in steps.dropFirst(index + 1) {
            leg.append(step)
            if step.junction.nilIfEmpty != nil { break }
        }
        let directed = leg.filter { $0.direction?.nilIfEmpty != nil }
        return (directed.max { $0.miles < $1.miles } ?? directed.first)?.direction
    }

    private func queries(for route: PermitRoute, summary: PermitDetailedRouteSummary) -> [RouteGeocodingQuery] {
        var queries = [RouteGeocodingQuery(
            place: route.origin,
            hint: RouteGeocodingHint(latitude: summary.originLatitude, longitude: summary.originLongitude),
            isStateLine: summary.originIsStateLine ?? false,
            nextDirection: summary.steps.lazy.compactMap { $0.direction?.nilIfEmpty }.first)]
        var miles = 0.0
        for (index, step) in summary.steps.enumerated() {
            miles += step.miles
            guard let junction = step.junction.nilIfEmpty else { continue }
            if queries.last?.place.caseInsensitiveCompare(junction) != .orderedSame {
                queries.append(RouteGeocodingQuery(
                    place: junction,
                    miles: miles,
                    hint: RouteGeocodingHint(latitude: step.junctionLatitude, longitude: step.junctionLongitude),
                    nextDirection: directionAfter(index, in: summary.steps)))
            }
            miles = 0
        }
        queries.append(RouteGeocodingQuery(
            place: route.destination,
            miles: miles,
            hint: RouteGeocodingHint(latitude: summary.destinationLatitude, longitude: summary.destinationLongitude),
            isStateLine: summary.destinationIsStateLine ?? false,
            nextDirection: summary.steps.reversed().lazy.compactMap { $0.direction?.nilIfEmpty }.first))
        return queries
    }

    private func isSamePermit(_ saved: PermitBrief, _ new: PermitBrief) -> Bool {
        let number = permitKey(new.number)
        return !number.isEmpty
            && saved.stateCode.uppercased() == new.stateCode.uppercased()
            && permitKey(saved.number) == number
    }

    private func permitKey(_ number: String) -> String {
        number.uppercased().filter { $0.isLetter || $0.isNumber }
    }

    private func fileNames(of record: PermitRecord) -> [String] {
        [record.pdfFileName] + record.attachmentFileNames
    }

    private func reload() {
        let descriptor = FetchDescriptor<PermitRecord>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        records = (try? context.fetch(descriptor)) ?? []
    }
}
