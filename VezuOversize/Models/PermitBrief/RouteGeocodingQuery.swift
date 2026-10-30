import Foundation

struct RouteGeocodingQuery: Hashable {
    let place: String
    var miles: Double = 0
    var hint: RouteGeocodingHint?
    var isStateLine = false
    var nextDirection: String?
}
