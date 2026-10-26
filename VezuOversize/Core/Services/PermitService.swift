import Foundation

protocol PermitServicable {
    func summarize(_ files: [PermitFile]) async throws -> PermitBrief
    func detailedRoute(_ files: [PermitFile]) async throws -> PermitDetailedRouteSummary
}

struct PermitService {
    private let networkService: NetworkServicable

    init(networkService: NetworkServicable = NetworkService()) {
        self.networkService = networkService
    }
}

extension PermitService: PermitServicable {
    func summarize(_ files: [PermitFile]) async throws -> PermitBrief {
        let response = try await networkService.request(
            .summarizePermit(request: SummarizePermitRequest(pdfs: files)),
            responseModel: PermitSummaryResponse.self)
        return try brief(from: response)
    }

    func detailedRoute(_ files: [PermitFile]) async throws -> PermitDetailedRouteSummary {
        try await networkService.request(
            .routePermit(request: SummarizePermitRequest(pdfs: files)),
            responseModel: PermitRouteResponse.self
        ).route
    }
}

private extension PermitService {
    func brief(from response: PermitSummaryResponse) throws -> PermitBrief {
        let summary = response.summary
        guard summary.stateCode.nilIfEmpty != nil || summary.number.nilIfEmpty != nil else {
            throw AppError.notAPermit
        }
        var reviewNotes = response.checks?.problems ?? []

        let validFrom = date(from: summary.validFrom)
        let validTo = date(from: summary.validTo)
        if validFrom == nil || validTo == nil {
            reviewNotes.append(AppText.PermitBrief.unreadableDates)
        }

        return PermitBrief(
            state: summary.state,
            stateCode: summary.stateCode.uppercased(),
            permitType: summary.permitType,
            number: summary.number,
            fee: Decimal(summary.fee),
            validFrom: validFrom ?? validTo ?? .now,
            validTo: validTo ?? validFrom ?? .now,
            restrictions: summary.restrictions.map(restriction),
            escorts: summary.escorts.map(escortRule),
            load: load(from: summary.load),
            vehicle: vehicle(from: summary.vehicle),
            route: route(from: summary.route),
            alerts: summary.alerts.map(item),
            equipment: summary.equipment.map(item),
            documents: summary.documents.map(item),
            contacts: summary.contacts.map(contact),
            critical: summary.critical.map(criticalInfo),
            reviewNotes: reviewNotes)
    }

    func date(from text: String) -> Date? {
        guard let match = text.firstMatch(of: #/(\d{1,2})/(\d{1,2})/(\d{4}|\d{2})/#),
              let month = Int(match.1), let day = Int(match.2), var year = Int(match.3) else { return nil }
        if year < 100 {
            year += 2000
        }
        return Calendar.current.date(from: DateComponents(year: year, month: month, day: day))
    }

    func restriction(from summary: PermitSummaryRestriction) -> PermitRestriction {
        PermitRestriction(kind: summary.kind, title: summary.title, detail: summary.detail.nilIfEmpty)
    }

    func escortRule(from summary: PermitSummaryEscort) -> PermitEscortRule {
        PermitEscortRule(
            count: max(summary.count, 1),
            position: summary.position,
            condition: summary.condition.nilIfEmpty)
    }

    func load(from summary: PermitSummaryLoad) -> PermitLoad {
        PermitLoad(
            description: summary.description,
            height: summary.height,
            width: summary.width,
            length: summary.length,
            grossWeight: summary.grossWeight.nilIfEmpty,
            axles: summary.axles > 0 ? summary.axles : nil)
    }

    func vehicle(from summary: PermitSummaryVehicle) -> PermitVehicle {
        PermitVehicle(
            year: summary.year.nilIfEmpty,
            make: summary.make.nilIfEmpty,
            type: summary.type.nilIfEmpty,
            unitNumber: summary.unitNumber.nilIfEmpty,
            plate: summary.plate.nilIfEmpty,
            plateState: summary.plateState.nilIfEmpty,
            vin: summary.vin.nilIfEmpty)
    }

    func route(from summary: PermitSummaryRoute) -> PermitRoute {
        PermitRoute(
            origin: summary.origin,
            destination: summary.destination,
            totalMiles: summary.totalMiles,
            prohibitedRoads: summary.prohibitedRoads,
            steps: summary.steps.map {
                PermitRouteStep(road: $0.road, instruction: $0.instruction, miles: $0.miles, isToll: $0.isToll)
            })
    }

    func item(from summary: PermitSummaryItem) -> PermitBriefItem {
        PermitBriefItem(title: summary.title, detail: summary.detail.nilIfEmpty)
    }

    func contact(from summary: PermitSummaryContact) -> PermitContact {
        PermitContact(name: summary.name, role: summary.role, phone: summary.phone)
    }

    func criticalInfo(from summary: PermitSummaryCritical) -> PermitCriticalInfo {
        PermitCriticalInfo(
            nightTravel: answer(from: summary.nightTravel),
            maxSpeed: answer(from: summary.maxSpeed),
            escorts: answer(from: summary.escorts))
    }

    func answer(from summary: PermitSummaryAnswer) -> PermitCriticalAnswer {
        PermitCriticalAnswer(
            status: summary.status,
            summary: summary.summary,
            quote: summary.quote.nilIfEmpty,
            mph: summary.mph.flatMap { $0 > 0 ? $0 : nil })
    }
}
