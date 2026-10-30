import Foundation

protocol GoogleMapsLinkServicable {
    func links(for waypoints: [RouteWaypoint]) -> [URL]
}

struct GoogleMapsLinkService {
    private func link(origin: RouteWaypoint?, stops: [RouteWaypoint]) -> URL? {
        guard let destination = stops.last else { return nil }
        var parameters = ["api=1", "travelmode=driving"]
        if let origin {
            parameters.append("origin=\(encoded(coordinates(of: origin)))")
        }
        parameters.append("destination=\(encoded(coordinates(of: destination)))")

        let between = stops.dropLast().map(coordinates)
        if !between.isEmpty {
            parameters.append("waypoints=\(encoded(between.joined(separator: "|")))")
        }
        return URL(string: Constants.baseURL + "?" + parameters.joined(separator: "&"))
    }

    private func coordinates(of waypoint: RouteWaypoint) -> String {
        String(format: "%.6f,%.6f", waypoint.latitude ?? 0, waypoint.longitude ?? 0)
    }

    private func encoded(_ text: String) -> String {
        text.replacing(",", with: "%2C").replacing("|", with: "%7C")
    }
}

extension GoogleMapsLinkService: GoogleMapsLinkServicable {
    func links(for waypoints: [RouteWaypoint]) -> [URL] {
        let points = waypoints.filter(\.isResolved)
        guard !points.isEmpty else { return [] }

        let startsFromCurrentLocation = waypoints.first?.isResolved == false || points.count == 1
        var links: [URL?] = []
        var startIndex = 0

        if startsFromCurrentLocation {
            let endIndex = min(Constants.maxStopsBetween, points.count - 1)
            links.append(link(origin: nil, stops: Array(points[0...endIndex])))
            startIndex = endIndex
        }
        while startIndex < points.count - 1 {
            let endIndex = min(startIndex + Constants.maxStopsBetween + 1, points.count - 1)
            links.append(link(origin: points[startIndex], stops: Array(points[(startIndex + 1)...endIndex])))
            startIndex = endIndex
        }
        return links.compactMap(\.self)
    }
}

private extension GoogleMapsLinkService {
    enum Constants {
        static let baseURL = "https://www.google.com/maps/dir/"
        static let maxStopsBetween = 9
    }
}
