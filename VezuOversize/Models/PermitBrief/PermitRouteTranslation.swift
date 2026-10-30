import Foundation

nonisolated struct PermitRouteTranslation: Hashable, Codable {
    let language: String
    let instructions: [String]
}
