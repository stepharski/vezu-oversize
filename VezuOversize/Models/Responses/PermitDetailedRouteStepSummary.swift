import Foundation

nonisolated struct PermitDetailedRouteStepSummary: Decodable, Sendable {
    let road: String
    let instruction: String
    let miles: Double
    let isToll: Bool
    var direction: String?
    let junction: String
    var junctionLatitude: Double?
    var junctionLongitude: Double?
}
