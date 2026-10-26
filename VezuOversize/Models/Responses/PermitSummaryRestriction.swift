import Foundation

nonisolated struct PermitSummaryRestriction: Decodable, Sendable {
    let kindName: String
    let title: String
    let detail: String

    enum CodingKeys: String, CodingKey {
        case kindName = "kind"
        case title
        case detail
    }
}

extension PermitSummaryRestriction {
    var kind: PermitRestriction.Kind {
        PermitRestriction.Kind(rawValue: kindName) ?? .other
    }
}
