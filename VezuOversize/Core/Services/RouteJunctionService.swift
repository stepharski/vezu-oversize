import Foundation

protocol RouteJunctionServicable {
    func shifted(_ waypoints: [RouteWaypoint], queries: [RouteGeocodingQuery]) async -> [RouteWaypoint]
}

struct RouteJunctionService {
    private let networkService: NetworkServicable

    init(networkService: NetworkServicable = NetworkService()) {
        self.networkService = networkService
    }
}

extension RouteJunctionService: RouteJunctionServicable {
    func shifted(_ waypoints: [RouteWaypoint], queries: [RouteGeocodingQuery]) async -> [RouteWaypoint] {
        let targets = waypoints.indices.compactMap { index -> (index: Int, point: LeadInPoint)? in
            guard queries.indices.contains(index),
                  let latitude = waypoints[index].latitude,
                  let longitude = waypoints[index].longitude else { return nil }
            let name = waypoints[index].name
            let isStart = index == waypoints.startIndex
            let isEnd = index == waypoints.endIndex - 1
            let heading = queries[index].nextDirection
            if isEnd && heading == nil { return nil }
            guard let road = isStart || isEnd ? firstHighway(in: name) : nextRoad(in: name) else { return nil }
            let next = isEnd ? nil : waypoints[(index + 1)...].first(where: \.isResolved).map {
                MapCoordinate(lat: $0.latitude ?? 0, lon: $0.longitude ?? 0)
            }
            let point = LeadInPoint(
                lat: latitude,
                lon: longitude,
                road: road,
                from: isStart || isEnd ? nil : thisRoad(in: name),
                next: next,
                heading: heading,
                leadIn: isEnd ? Constants.endSnapMeters : leadIn(after: index, in: queries))
            return (index, point)
        }
        guard !targets.isEmpty else { return waypoints }

        let placed = try? await networkService.request(
            .leadIns(request: LeadInRequest(points: targets.map(\.point))),
            responseModel: LeadInResponse.self)
            .points

        var shifted = waypoints
        for (offset, target) in targets.enumerated() {
            if let point = placed?.indices.contains(offset) == true ? placed?[offset] : nil {
                shifted[target.index].latitude = point.lat
                shifted[target.index].longitude = point.lon
            } else if target.index == waypoints.startIndex {
                shifted[target.index].latitude = nil
                shifted[target.index].longitude = nil
            }
        }
        return shifted
    }
}

private extension RouteJunctionService {
    func leadIn(after index: Int, in queries: [RouteGeocodingQuery]) -> Double {
        let legMiles = queries.indices.contains(index + 1) ? queries[index + 1].miles : 0
        guard legMiles > 0 else { return Constants.leadInMeters }
        return min(Constants.leadInMeters, legMiles * DistanceConstants.metersPerMile * Constants.maxLegShare)
    }

    func firstHighway(in place: String) -> String? {
        guard let road = thisRoad(in: place) else { return nil }
        return road.firstMatch(of: /^[A-Za-z]{1,3}[- ]?\d+[A-Za-z]?$/) != nil ? road : nil
    }

    func thisRoad(in place: String) -> String? {
        roads(in: place).first
    }

    func nextRoad(in place: String) -> String? {
        let roads = roads(in: place)
        return roads.count == 2 ? roads[1] : nil
    }

    func roads(in place: String) -> [String] {
        (place.split(separator: ",").first.map(String.init) ?? place)
            .components(separatedBy: " & ")
            .compactMap { $0.trimmingCharacters(in: .whitespaces).nilIfEmpty }
    }
}

private extension RouteJunctionService {
    enum Constants {
        static let leadInMeters = 1_600.0
        static let endSnapMeters = 150.0
        static let maxLegShare = 0.4
    }
}
