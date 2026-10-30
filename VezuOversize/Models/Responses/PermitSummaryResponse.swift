import Foundation

nonisolated struct PermitSummaryResponse: Decodable, Sendable {
    let summary: PermitSummary
    let translation: PermitSummaryTranslation?
    let checks: PermitSummaryChecks?
}

nonisolated struct PermitSummaryTranslation: Decodable, Sendable {
    let language: String
    let summary: PermitSummary
}
