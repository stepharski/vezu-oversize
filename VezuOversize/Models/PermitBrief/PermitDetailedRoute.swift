import Foundation

nonisolated struct PermitDetailedRoute: Hashable, Codable {
    let route: PermitRoute
    let waypoints: [RouteWaypoint]

    var resolvedWaypoints: [RouteWaypoint] {
        waypoints.filter(\.isResolved)
    }
}
