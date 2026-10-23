import Foundation

nonisolated struct PermitSummaryLoad: Decodable, Sendable {
    let description: String
    let length: String
    let width: String
    let height: String
    let grossWeight: String
    let axles: Int
}
