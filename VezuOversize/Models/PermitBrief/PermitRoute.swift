import Foundation

nonisolated struct PermitRoute: Hashable, Codable {
    let origin: String
    let destination: String
    let totalMiles: Double
    let prohibitedRoads: [String]
    let steps: [PermitRouteStep]
}
