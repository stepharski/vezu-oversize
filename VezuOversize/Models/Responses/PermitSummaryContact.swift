import Foundation

nonisolated struct PermitSummaryContact: Decodable, Sendable {
    let name: String
    let role: String
    let phone: String
}
