import Foundation

@Observable
final class RouteDetailViewModel {
    let brief: PermitBrief
    private(set) var detailedRoute: PermitDetailedRoute?
    private(set) var detailState: RouteDetailState
    var isNavigationPresented = false
    private(set) var mapsLinks: [URL] = []

    private let permitManager: PermitManager
    private let mapsLinkBuilder = GoogleMapsRouteLinks()

    init(brief: PermitBrief, permitManager: PermitManager) {
        self.brief = brief
        self.permitManager = permitManager
        detailState = permitManager.contains(brief) ? .loading : .unavailable
    }

    var route: PermitRoute {
        detailedRoute?.route ?? brief.route
    }

    var waypoints: [RouteWaypoint] {
        detailedRoute?.waypoints ?? []
    }

    var canNavigate: Bool {
        !(detailedRoute?.resolvedWaypoints.isEmpty ?? true)
    }

    var unresolvedCount: Int {
        waypoints.dropFirst().filter { !$0.isResolved }.count
    }

    func load() async {
        guard detailState != .unavailable, detailedRoute == nil else { return }
        detailState = .loading
        do {
            detailedRoute = try await permitManager.detailedRoute(for: brief)
            detailState = .ready
        } catch {
            detailState = .failed((error as? AppError ?? .invalidResponse).message)
        }
    }

    func navigateTapped() {
        guard let detailedRoute else { return }
        mapsLinks = mapsLinkBuilder.links(for: detailedRoute.waypoints)
        isNavigationPresented = true
    }
}
