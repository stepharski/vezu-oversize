import Foundation

nonisolated struct PermitSummaryChecks: Decodable, Sendable {
    let problems: [String]
}
