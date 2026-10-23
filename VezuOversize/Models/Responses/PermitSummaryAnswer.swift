import Foundation

nonisolated struct PermitSummaryAnswer: Decodable, Sendable {
    let statusName: String
    let summary: String
    let quote: String
    let mph: Int?

    enum CodingKeys: String, CodingKey {
        case statusName = "status"
        case summary
        case quote
        case mph
    }
}

extension PermitSummaryAnswer {
    var status: PermitCriticalAnswer.Status {
        PermitCriticalAnswer.Status(rawValue: statusName) ?? .notStated
    }
}
