import Foundation

struct PlacesRequest: Encodable, Equatable {
    let state: String?
    let places: [PlaceQuery]
}
