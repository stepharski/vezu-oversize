import Foundation

nonisolated struct PermitSummaryRouteStep: Decodable, Sendable {
    let road: String
    let instruction: String
    let miles: Double
    let isToll: Bool
}
