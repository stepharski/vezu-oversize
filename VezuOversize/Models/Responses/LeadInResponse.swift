import Foundation

nonisolated struct LeadInResponse: Decodable, Sendable {
    let points: [MapCoordinate?]
}
