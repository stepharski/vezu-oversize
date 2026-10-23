import Foundation

nonisolated struct PermitSummaryResponse: Decodable, Sendable {
    let summary: PermitSummary
    let checks: PermitSummaryChecks?
}
