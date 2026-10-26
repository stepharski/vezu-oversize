import Foundation

nonisolated struct PlacesResponse: Decodable, Sendable {
    let places: [PlaceResult]
}
