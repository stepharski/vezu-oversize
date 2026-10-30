import Foundation

nonisolated struct PermitDetailedRoute: Hashable, Codable {
    let route: PermitRoute
    let waypoints: [RouteWaypoint]
    var translation: PermitRouteTranslation?

    var resolvedWaypoints: [RouteWaypoint] {
        waypoints.filter(\.isResolved)
    }

    // The route with step instructions in the app's language when they were translated into it.
    var localized: PermitDetailedRoute {
        guard let translation,
              translation.language == Bundle.main.languageCode,
              translation.instructions.count == route.steps.count
        else { return self }

        let steps = zip(route.steps, translation.instructions).map { step, instruction in
            PermitRouteStep(id: step.id, road: step.road, instruction: instruction, miles: step.miles, isToll: step.isToll)
        }
        let localizedRoute = PermitRoute(
            origin: route.origin,
            destination: route.destination,
            totalMiles: route.totalMiles,
            prohibitedRoads: route.prohibitedRoads,
            steps: steps)
        return PermitDetailedRoute(route: localizedRoute, waypoints: waypoints, translation: translation)
    }
}
