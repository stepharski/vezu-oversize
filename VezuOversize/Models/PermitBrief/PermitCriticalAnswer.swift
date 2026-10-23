import Foundation

nonisolated struct PermitCriticalAnswer: Hashable, Codable {
    enum Status: String, Hashable, Codable {
        case allowed
        case prohibited
        case conditional
        case stated
        case required
        case notRequired
        case notStated
    }

    let status: Status
    let summary: String
    let quote: String?
    let mph: Int?
}

extension PermitCriticalAnswer {
    var isStated: Bool {
        status != .notStated
    }
}
