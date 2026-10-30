import Foundation

struct Permit: Identifiable, Hashable {
    var id = UUID()
    let title: String
    let stateCode: String
    let number: String
    let loadDescription: String
    let validFrom: Date
    let validTo: Date
    let status: PermitStatus
}

extension Permit {
    init(id: UUID, brief: PermitBrief) {
        self.init(
            id: id,
            title: brief.state,
            stateCode: brief.stateCode,
            number: brief.number,
            loadDescription: brief.load.description,
            validFrom: brief.validFrom,
            validTo: brief.validTo,
            status: brief.status)
    }
}

