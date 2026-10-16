import Foundation

struct PermitBrief: Identifiable, Hashable {
    let id: UUID
    let state: String
    let permitType: String
    let number: String
    let fee: Decimal
    let validFrom: Date
    let validTo: Date
    let restrictions: [Restriction]
    let escorts: [EscortRule]
    let load: LoadInfo
    let vehicle: VehicleInfo
    let route: RouteInfo
    let alerts: [Item]
    let equipment: [Item]
    let documents: [Item]
    let contacts: [Contact]

    init(
        id: UUID = UUID(),
        state: String,
        permitType: String,
        number: String,
        fee: Decimal,
        validFrom: Date,
        validTo: Date,
        restrictions: [Restriction],
        escorts: [EscortRule],
        load: LoadInfo,
        vehicle: VehicleInfo,
        route: RouteInfo,
        alerts: [Item],
        equipment: [Item],
        documents: [Item],
        contacts: [Contact]
    ) {
        self.id = id
        self.state = state
        self.permitType = permitType
        self.number = number
        self.fee = fee
        self.validFrom = validFrom
        self.validTo = validTo
        self.restrictions = restrictions
        self.escorts = escorts
        self.load = load
        self.vehicle = vehicle
        self.route = route
        self.alerts = alerts
        self.equipment = equipment
        self.documents = documents
        self.contacts = contacts
    }
}

// MARK: - Restriction
extension PermitBrief {
    struct Restriction: Identifiable, Hashable {
        enum Kind: Hashable {
            case speed
            case travelHours
            case nightTravel
            case weekend
            case holiday
            case weather
            case other

            var systemImage: String {
                switch self {
                case .speed: "gauge.with.needle"
                case .travelHours: "clock"
                case .nightTravel: "moon.stars"
                case .weekend: "calendar"
                case .holiday: "calendar.badge.exclamationmark"
                case .weather: "cloud.rain"
                case .other: "info.circle"
                }
            }
        }

        let id = UUID()
        let kind: Kind
        let title: String
        let detail: String?
    }
}

// MARK: - Escort
extension PermitBrief {
    struct EscortRule: Identifiable, Hashable {
        enum Position: Hashable {
            case front
            case rear
            case frontAndRear
            case unspecified
        }

        let id = UUID()
        let count: Int
        let position: Position
        let condition: String?
    }
}

// MARK: - Load
extension PermitBrief {
    struct LoadInfo: Hashable {
        let description: String
        let height: String
        let width: String
        let length: String
        let grossWeight: String?
        let axles: Int?
    }
}

// MARK: - Vehicle
extension PermitBrief {
    struct VehicleInfo: Hashable {
        let year: String?
        let make: String?
        let type: String?
        let unitNumber: String?
        let plate: String?
        let plateState: String?
        let vin: String?
    }
}

// MARK: - Route
extension PermitBrief {
    struct RouteInfo: Hashable {
        let origin: String
        let destination: String
        let totalMiles: Double
        let prohibitedRoads: [String]
        let steps: [RouteStep]
    }

    struct RouteStep: Identifiable, Hashable {
        let id = UUID()
        let road: String
        let instruction: String
        let miles: Double
        var isToll = false
    }
}

// MARK: - Item
extension PermitBrief {
    /// A titled note used for alerts, required equipment, and documents.
    struct Item: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let detail: String?
    }
}

// MARK: - Contact
extension PermitBrief {
    struct Contact: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let role: String
        let phone: String
    }
}

// MARK: - Demo
extension PermitBrief {
    private static func date(_ month: Int, _ day: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: 2026, month: month, day: day)) ?? .now
    }

    static let demo = PermitBrief(
        state: "Indiana",
        permitType: "Oversize Single Trip",
        number: "892 0795 126",
        fee: 35,
        validFrom: date(9, 22),
        validTo: date(9, 26),
        restrictions: [
            Restriction(kind: .speed, title: "Max 55 mph", detail: "Load is over 85' long"),
            Restriction(kind: .travelHours, title: "Travel 24/7", detail: "Continuous travel 7 days a week"),
            Restriction(kind: .weather, title: "No travel in bad weather", detail: "Visibility under 500 ft or wind over 25 mph"),
            Restriction(kind: .holiday, title: "Holiday restrictions", detail: "No travel from noon the weekday before a major holiday")
        ],
        escorts: [],
        load: LoadInfo(
            description: "Steel pipe, 1 pc",
            height: "13' 6\"",
            width: "8' 6\"",
            length: "104' 0\"",
            grossWeight: "80,000 lbs",
            axles: 5
        ),
        vehicle: VehicleInfo(
            year: "2020",
            make: "Volvo",
            type: "Tractor-Trailer",
            unitNumber: "017",
            plate: "P1324917",
            plateState: "IL",
            vin: "4V4NC9EH3LN266494"
        ),
        route: RouteInfo(
            origin: "I-70 at IL line",
            destination: "I-80 at OH line",
            totalMiles: 267.3,
            prohibitedRoads: ["I-65", "I-70 inside I-465", "County roads and city streets"],
            steps: [
                RouteStep(road: "I-70 East", instruction: "Take Exit 69 toward I-465/I-74", miles: 68.7),
                RouteStep(road: "I-70 Connector East", instruction: "Continue straight on I-70", miles: 3.8),
                RouteStep(road: "I-70 South", instruction: "Merge onto I-465", miles: 0.1),
                RouteStep(road: "I-465 South", instruction: "Take Exit 37 toward I-69/SR-37 North/Ft Wayne", miles: 24.8),
                RouteStep(road: "I-465 Ramp North", instruction: "Continue straight on I-69", miles: 0.7),
                RouteStep(road: "I-69 North", instruction: "Take Exit 356 toward I-80/I-90/Chicago/Toledo", miles: 155.8),
                RouteStep(road: "I-69 Ramp North", instruction: "Bear right onto I-80 Ramp", miles: 0.3),
                RouteStep(road: "I-80 Ramp East", instruction: "Continue straight on I-80", miles: 0.5, isToll: true),
                RouteStep(road: "I-80 East", instruction: "Arrive at destination", miles: 12.6)
            ]
        ),
        alerts: [
            Item(title: "I-70 construction", detail: "Between Tabortown St and Little Point Rd: both shoulders closed"),
            Item(title: "Check road restrictions before travel", detail: "intr.carsprogram.org")
        ],
        equipment: [
            Item(title: "\"OVER-SIZE LOAD\" signs", detail: "Front and rear, black on yellow, 18\" high, 6–8 ft long"),
            Item(title: "2 red or orange flags", detail: "18\" square, at the widest points of the load"),
            Item(title: "Low-beam headlights on", detail: "At all times while moving")
        ],
        documents: [
            Item(title: "Permit", detail: "Show on demand to police or inspectors"),
            Item(title: "General Provisions (M-204)", detail: "Permit is void if not carried")
        ],
        contacts: [
            Contact(name: "Indiana Dept. of Revenue", role: "Permit office", phone: "(317) 615-7200"),
            Contact(name: "GMAX Logistics", role: "Carrier", phone: "(331) 575-1435")
        ]
    )

    static let demoIllinois = PermitBrief(
        state: "Illinois",
        permitType: "OS/OW Single Trip",
        number: "R38742500",
        fee: 40,
        validFrom: date(9, 22),
        validTo: date(9, 27),
        restrictions: [
            Restriction(kind: .nightTravel, title: "Night travel with escort", detail: "From ½ hr after sunset to ½ hr before sunrise: 1 escort and check night lane closures first")
        ],
        escorts: [
            EscortRule(count: 1, position: .unspecified, condition: "Night travel only")
        ],
        load: LoadInfo(
            description: "Steel pipe",
            height: "13' 6\"",
            width: "8' 6\"",
            length: "104' 0\"",
            grossWeight: nil,
            axles: nil
        ),
        vehicle: VehicleInfo(
            year: "2020",
            make: nil,
            type: nil,
            unitNumber: nil,
            plate: "P1324917",
            plateState: "IL",
            vin: "4V4NC9EH3LN266494"
        ),
        route: RouteInfo(
            origin: "I-270 at MO line",
            destination: "I-70 at IN line",
            totalMiles: 155.7,
            prohibitedRoads: [],
            steps: [
                RouteStep(road: "I-270", instruction: "Go on I-270", miles: 14.2),
                RouteStep(road: "I-270", instruction: "At fork keep left toward Indianapolis / I-70 E", miles: 0.4),
                RouteStep(road: "I-270", instruction: "At fork keep left on I-270", miles: 0.6),
                RouteStep(road: "I-70", instruction: "Go on I-70", miles: 77.3),
                RouteStep(road: "I-57", instruction: "Go on I-57", miles: 5.4),
                RouteStep(road: "I-70", instruction: "At fork keep right on I-70", miles: 57.8)
            ]
        ),
        alerts: [
            Item(title: "Check night closures before night travel", detail: "Temporary Nighttime Lane and Ramp Closure reports on ITAP")
        ],
        equipment: [],
        documents: [
            Item(title: "Original permit", detail: "Plus any revisions or extensions; electronic copy is OK"),
            Item(title: "Form OPER 993", detail: nil)
        ],
        contacts: [
            Contact(name: "IDOT Permit Office", role: "Permit office", phone: "(217) 785-1477"),
            Contact(name: "Max Zaikin", role: "Permit service", phone: "(773) 540-8441")
        ]
    )
}
