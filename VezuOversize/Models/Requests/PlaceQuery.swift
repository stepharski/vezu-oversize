import Foundation

struct PlaceQuery: Encodable, Equatable {
    let place: String
    let hint: MapCoordinate?
    let isStateLine: Bool
    let miles: Double
    let previous: MapCoordinate?
}
