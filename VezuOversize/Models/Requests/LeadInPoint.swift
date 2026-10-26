import Foundation

nonisolated struct LeadInPoint: Encodable, Equatable, Sendable {
    let lat: Double
    let lon: Double
    let road: String
    let from: String?
    let next: MapCoordinate?
    let heading: String?
    let leadIn: Double
}
