import Foundation

nonisolated struct PermitRouteStep: Identifiable, Hashable, Codable {
    var id = UUID()
    let road: String
    let instruction: String
    let miles: Double
    var isToll = false
}
