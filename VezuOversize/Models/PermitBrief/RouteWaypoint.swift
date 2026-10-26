import Foundation

nonisolated struct RouteWaypoint: Identifiable, Hashable, Codable {
    var id = UUID()
    let name: String
    var latitude: Double?
    var longitude: Double?

    var isResolved: Bool {
        latitude != nil && longitude != nil
    }
}
