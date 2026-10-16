import Foundation

struct Permit: Identifiable, Hashable {
    let id: UUID
    let title: String
    let stateCode: String
    let number: String
    let loadDescription: String
    let validFrom: Date
    let validTo: Date
    let status: PermitStatus

    init(
        id: UUID = UUID(),
        title: String,
        stateCode: String,
        number: String,
        loadDescription: String,
        validFrom: Date,
        validTo: Date,
        status: PermitStatus
    ) {
        self.id = id
        self.title = title
        self.stateCode = stateCode
        self.number = number
        self.loadDescription = loadDescription
        self.validFrom = validFrom
        self.validTo = validTo
        self.status = status
    }
}

// MARK: - Samples
extension Permit {
    private static func date(_ month: Int, _ day: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: 2026, month: month, day: day)) ?? .now
    }

    static let samples: [Permit] = [
        Permit(
            title: "Illinois Oversize",
            stateCode: "IL",
            number: "R38742500",
            loadDescription: "Steel pipe",
            validFrom: date(10, 14),
            validTo: date(10, 18),
            status: .active
        ),
        Permit(
            title: "Indiana Oversize",
            stateCode: "IN",
            number: "892 0795 126",
            loadDescription: "Steel pipe",
            validFrom: date(10, 15),
            validTo: date(10, 19),
            status: .active
        ),
        Permit(
            title: "Ohio Oversize",
            stateCode: "OH",
            number: "556221",
            loadDescription: "Transformer",
            validFrom: date(9, 2),
            validTo: date(9, 5),
            status: .expired
        ),
        Permit(
            title: "New York Oversize",
            stateCode: "NY",
            number: "990114",
            loadDescription: "Excavator",
            validFrom: date(8, 18),
            validTo: date(8, 22),
            status: .expired
        ),
        Permit(
            title: "Wisconsin Oversize",
            stateCode: "WI",
            number: "940104",
            loadDescription: "Wind turbine blade",
            validFrom: date(8, 4),
            validTo: date(8, 8),
            status: .expired
        )
    ]
}
