import Foundation

nonisolated struct PlaceResult: Decodable, Sendable {
    let status: String
    let lat: Double?
    let lon: Double?

    var coordinate: MapCoordinate? {
        guard status == "found", let lat, let lon else { return nil }
        return MapCoordinate(lat: lat, lon: lon)
    }
}
