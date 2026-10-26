import Foundation

nonisolated struct PermitSummaryCritical: Decodable, Sendable {
    let nightTravel: PermitSummaryAnswer
    let maxSpeed: PermitSummaryAnswer
    let escorts: PermitSummaryAnswer
}
