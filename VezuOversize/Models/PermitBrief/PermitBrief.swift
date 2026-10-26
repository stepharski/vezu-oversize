import Foundation

nonisolated struct PermitBrief: Identifiable, Hashable, Codable {
    var id = UUID()
    let state: String
    let stateCode: String
    let permitType: String
    let number: String
    let fee: Decimal
    let validFrom: Date
    let validTo: Date
    let restrictions: [PermitRestriction]
    let escorts: [PermitEscortRule]
    let load: PermitLoad
    let vehicle: PermitVehicle
    let route: PermitRoute
    let alerts: [PermitBriefItem]
    let equipment: [PermitBriefItem]
    let documents: [PermitBriefItem]
    let contacts: [PermitContact]
    var critical: PermitCriticalInfo?
    var reviewNotes: [String]?
}

nonisolated extension PermitBrief {
    var status: PermitStatus {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        if today < calendar.startOfDay(for: validFrom) {
            return .upcoming
        }
        return today > calendar.startOfDay(for: validTo) ? .expired : .active
    }
}

nonisolated extension PermitBrief {
    private static func date(_ month: Int, _ day: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: 2026, month: month, day: day)) ?? .now
    }

    static let demoCritical = PermitCriticalInfo(
        nightTravel: PermitCriticalAnswer(
            status: .allowed,
            summary: "Continuous travel is allowed, including at night.",
            quote: "Continuous travel 7 days a week",
            mph: nil),
        maxSpeed: PermitCriticalAnswer(
            status: .stated,
            summary: "Keep to 55 mph or less while the load is over 85' long.",
            quote: "Maximum speed 55 mph when length exceeds 85 feet",
            mph: 55),
        escorts: PermitCriticalAnswer(
            status: .notRequired,
            summary: "No escort is required for this load.",
            quote: "Escort: None",
            mph: nil))

    static let demo = PermitBrief(
        state: "Indiana",
        stateCode: "IN",
        permitType: "Oversize Single Trip",
        number: "892 0795 126",
        fee: 35,
        validFrom: date(9, 22),
        validTo: date(9, 26),
        restrictions: [
            PermitRestriction(kind: .speed, title: "Max 55 mph", detail: "Load is over 85' long"),
            PermitRestriction(kind: .travelHours, title: "Travel 24/7", detail: "Continuous travel 7 days a week"),
            PermitRestriction(kind: .weather, title: "No travel in bad weather", detail: "Visibility under 500 ft or wind over 25 mph"),
            PermitRestriction(kind: .holiday, title: "Holiday restrictions", detail: "No travel from noon the weekday before a major holiday")
        ],
        escorts: [],
        load: PermitLoad(
            description: "Steel pipe, 1 pc",
            height: "13' 6\"",
            width: "8' 6\"",
            length: "104' 0\"",
            grossWeight: "80,000 lbs",
            axles: 5
        ),
        vehicle: PermitVehicle(
            year: "2020",
            make: "Volvo",
            type: "Tractor-Trailer",
            unitNumber: "017",
            plate: "P1324917",
            plateState: "IL",
            vin: "4V4NC9EH3LN266494"
        ),
        route: PermitRoute(
            origin: "I-70 at IL line",
            destination: "I-80 at OH line",
            totalMiles: 267.3,
            prohibitedRoads: ["I-65", "I-70 inside I-465", "County roads and city streets"],
            steps: [
                PermitRouteStep(road: "I-70 East", instruction: "Take Exit 69 toward I-465/I-74", miles: 68.7),
                PermitRouteStep(road: "I-70 Connector East", instruction: "Continue straight on I-70", miles: 3.8),
                PermitRouteStep(road: "I-70 South", instruction: "Merge onto I-465", miles: 0.1),
                PermitRouteStep(road: "I-465 South", instruction: "Take Exit 37 toward I-69/SR-37 North/Ft Wayne", miles: 24.8),
                PermitRouteStep(road: "I-465 Ramp North", instruction: "Continue straight on I-69", miles: 0.7),
                PermitRouteStep(road: "I-69 North", instruction: "Take Exit 356 toward I-80/I-90/Chicago/Toledo", miles: 155.8),
                PermitRouteStep(road: "I-69 Ramp North", instruction: "Bear right onto I-80 Ramp", miles: 0.3),
                PermitRouteStep(road: "I-80 Ramp East", instruction: "Continue straight on I-80", miles: 0.5, isToll: true),
                PermitRouteStep(road: "I-80 East", instruction: "Arrive at destination", miles: 12.6)
            ]
        ),
        alerts: [
            PermitBriefItem(title: "I-70 construction", detail: "Between Tabortown St and Little Point Rd: both shoulders closed"),
            PermitBriefItem(title: "Check road restrictions before travel", detail: "intr.carsprogram.org")
        ],
        equipment: [
            PermitBriefItem(title: "\"OVER-SIZE LOAD\" signs", detail: "Front and rear, black on yellow, 18\" high, 6–8 ft long"),
            PermitBriefItem(title: "2 red or orange flags", detail: "18\" square, at the widest points of the load"),
            PermitBriefItem(title: "Low-beam headlights on", detail: "At all times while moving")
        ],
        documents: [
            PermitBriefItem(title: "Permit", detail: "Show on demand to police or inspectors"),
            PermitBriefItem(title: "General Provisions (M-204)", detail: "Permit is void if not carried")
        ],
        contacts: [
            PermitContact(name: "Indiana Dept. of Revenue", role: "Permit office", phone: "(317) 615-7200"),
            PermitContact(name: "GMAX Logistics", role: "Carrier", phone: "(331) 575-1435")
        ],
        critical: demoCritical)
}
