import Foundation

enum RouteDetailState: Equatable {
    case unavailable
    case loading
    case ready
    case failed(String)
}
