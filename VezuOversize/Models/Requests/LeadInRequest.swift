import Foundation

nonisolated struct LeadInRequest: Encodable, Equatable, Sendable {
    let points: [LeadInPoint]
}
