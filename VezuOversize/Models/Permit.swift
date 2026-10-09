import Foundation

struct Permit: Identifiable, Hashable {
    let id: UUID
    let title: String
    let number: String
    let status: PermitStatus

    init(id: UUID = UUID(), title: String, number: String, status: PermitStatus) {
        self.id = id
        self.title = title
        self.number = number
        self.status = status
    }
}

// MARK: - Samples
extension Permit {
    static let samples: [Permit] = {
        return [
            Permit(title: "Illinois Oversize", number: "048291", status: .active),
            Permit(title: "Indiana Oversize", number: "117309", status: .active),
            Permit(title: "Ohio Oversize", number: "556221", status: .expired),
            Permit(title: "New York Oversize", number: "990114", status: .expired),
            Permit(title: "Wisconsin Oversize", number: "940104", status: .expired)
        ]
    }()
}
