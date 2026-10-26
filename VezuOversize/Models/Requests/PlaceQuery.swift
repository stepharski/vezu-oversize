import Foundation

nonisolated struct PlaceQuery: Encodable, Equatable, Sendable {
    let place: String
    let hint: MapCoordinate?
    let isStateLine: Bool
    let miles: Double
    let previous: MapCoordinate?
}
