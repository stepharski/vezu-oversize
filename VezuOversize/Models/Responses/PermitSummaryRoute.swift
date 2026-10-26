import Foundation

nonisolated struct PermitSummaryRoute: Decodable, Sendable {
    let origin: String
    let destination: String
    let totalMiles: Double
    let prohibitedRoads: [String]
    let steps: [PermitSummaryRouteStep]
}
