import Foundation

// Route step instructions in the language the app used when the route was read, in step order.
nonisolated struct PermitRouteTranslation: Hashable, Codable, Sendable {
    let language: String
    let instructions: [String]
}
