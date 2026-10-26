import Foundation

nonisolated struct PermitSummaryEscort: Decodable, Sendable {
    let count: Int
    let positionName: String
    let condition: String

    enum CodingKeys: String, CodingKey {
        case count
        case positionName = "position"
        case condition
    }
}

extension PermitSummaryEscort {
    var position: PermitEscortRule.Position {
        PermitEscortRule.Position(rawValue: positionName) ?? .unspecified
    }
}
