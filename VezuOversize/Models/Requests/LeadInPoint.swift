import Foundation

struct LeadInPoint: Encodable, Equatable {
    let lat: Double
    let lon: Double
    let road: String
    let from: String?
    let next: MapCoordinate?
    let heading: String?
    let leadIn: Double
}
