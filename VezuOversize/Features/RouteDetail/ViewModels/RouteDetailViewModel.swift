import Foundation

@Observable
final class RouteDetailViewModel {
    let brief: PermitBrief
    var isNavigationPresented = false

    private(set) var detailedRoute: PermitDetailedRoute?
    private(set) var detailState: RouteDetailState
    private(set) var mapsLinks: [URL] = []

    private let permitManager: PermitManager
    private let mapsLinkService: GoogleMapsLinkServicable

    init(brief: PermitBrief,
         permitManager: PermitManager,
         mapsLinkService: GoogleMapsLinkServicable = GoogleMapsLinkService()) {
        self.brief = brief
        self.permitManager = permitManager
        self.mapsLinkService = mapsLinkService
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

    func didTapNavigate() {
        guard let detailedRoute else { return }
        mapsLinks = mapsLinkService.links(for: detailedRoute.waypoints)
        isNavigationPresented = true
    }
}
