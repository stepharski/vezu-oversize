import Foundation

nonisolated struct PlacesRequest: Encodable, Equatable, Sendable {
    let state: String?
    let places: [PlaceQuery]
}
