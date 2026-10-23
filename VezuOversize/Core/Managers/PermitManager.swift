import Foundation
import SwiftData

@Observable
final class PermitManager {
    private(set) var records: [PermitRecord] = []
    private let context: ModelContext
    private let fileService: PermitFileServicable

    init(context: ModelContext, fileService: PermitFileServicable = PermitFileService()) {
        self.context = context
        self.fileService = fileService
        reload()
    }

    // A re-imported permit replaces the saved copy with the same state and number; a reload
    // replaces the record it was read from. Files the new record still uses are kept.
    func add(_ brief: PermitBrief, id: UUID, pdfFileNames: [String], replacing replacedID: UUID? = nil) throws {
        let duplicates = records.filter { record in
            record.id == replacedID || (record.brief.map { isSamePermit($0, brief) } ?? false)
        }
        let replacedFileNames = duplicates.flatMap(fileNames).filter { !pdfFileNames.contains($0) }
        duplicates.forEach(context.delete)

        context.insert(try PermitRecord(id: id, pdfFileNames: pdfFileNames, brief: brief))
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

    // The demo permit and other unsaved briefs have no record.
    func contains(_ brief: PermitBrief) -> Bool {
        record(for: brief) != nil
    }

    func recordID(for brief: PermitBrief) -> UUID? {
        record(for: brief)?.id
    }

    // Saved PDF copies that still exist on disk, the permit first.
    func savedFileNames(for brief: PermitBrief) -> [String] {
        guard let record = record(for: brief) else { return [] }
        return fileNames(of: record).filter { fileName in
            (try? fileService.url(for: fileName)).map { FileManager.default.fileExists(atPath: $0.path(percentEncoded: false)) } ?? false
        }
    }

    func fileURLs(for brief: PermitBrief) -> [URL] {
        savedFileNames(for: brief).compactMap { try? fileService.url(for: $0) }
    }

    func delete(_ brief: PermitBrief) throws {
        guard let record = record(for: brief) else { return }
        try delete(id: record.id)
    }

    private func record(for brief: PermitBrief) -> PermitRecord? {
        records.first { $0.brief?.id == brief.id }
    }

    private func isSamePermit(_ saved: PermitBrief, _ new: PermitBrief) -> Bool {
        let number = permitKey(new.number)
        return !number.isEmpty
            && saved.stateCode.uppercased() == new.stateCode.uppercased()
            && permitKey(saved.number) == number
    }

    // "892 0795 126" and "892-0795-126" are the same permit number.
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
