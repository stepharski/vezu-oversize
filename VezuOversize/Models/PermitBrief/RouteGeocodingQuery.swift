import Foundation

nonisolated struct RouteGeocodingQuery: Hashable, Sendable {
    let place: String
    var miles: Double = 0
    var hint: RouteGeocodingHint?
    var isStateLine = false
    var nextDirection: String?
}
