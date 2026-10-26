import Foundation

nonisolated struct PermitRouteResponse: Decodable, Sendable {
    let route: PermitDetailedRouteSummary
}
