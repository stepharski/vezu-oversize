import Foundation

nonisolated struct PermitDetailedRouteSummary: Decodable, Sendable {
    let origin: String
    let destination: String
    let totalMiles: Double
    var originLatitude: Double?
    var originLongitude: Double?
    var originIsStateLine: Bool?
    var destinationLatitude: Double?
    var destinationLongitude: Double?
    var destinationIsStateLine: Bool?
    let steps: [PermitDetailedRouteStepSummary]
}
