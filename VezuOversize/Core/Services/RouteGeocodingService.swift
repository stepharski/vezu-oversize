import MapKit

protocol RouteGeocodingServicable {
    func waypoints(for queries: [RouteGeocodingQuery], in state: String?) async -> [RouteWaypoint]
}

struct RouteGeocodingService {
    private let networkService: NetworkServicable

    init(networkService: NetworkServicable = NetworkService()) {
        self.networkService = networkService
    }
}

extension RouteGeocodingService: RouteGeocodingServicable {
    func waypoints(for queries: [RouteGeocodingQuery], in state: String?) async -> [RouteWaypoint] {
        var waypoints: [RouteWaypoint] = []
        var previous: CLLocation?
        var milesSincePrevious = 0.0

        for (index, query) in queries.enumerated() {
            milesSincePrevious += query.miles
            var waypoint = RouteWaypoint(name: query.place)
            if let point = await placeFromMapData(query, after: previous, miles: milesSincePrevious, in: state) {
                waypoint.latitude = point.lat
                waypoint.longitude = point.lon
                previous = CLLocation(latitude: point.lat, longitude: point.lon)
                milesSincePrevious = 0
                waypoints.append(waypoint)
                continue
            }
            let accepts = { (match: MapMatch) in isAllowed(match, for: query, in: state) }
            let found = if let hint = query.hint {
                await coordinate(
                    of: query.place,
                    near: hint,
                    within: acceptRadius(at: index, in: queries),
                    accepts: accepts)
            } else {
                await coordinate(of: query.place, after: previous, miles: milesSincePrevious, accepts: accepts)
            }
            if let coordinate = found {
                waypoint.latitude = coordinate.latitude
                waypoint.longitude = coordinate.longitude
                previous = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                milesSincePrevious = 0
            }
            waypoints.append(waypoint)
        }
        await findStart(of: &waypoints, queries: queries, in: state)
        dropStartOnTopOfNext(in: &waypoints)
        dropStateLineEndsOnWrongSide(in: &waypoints, queries: queries, state: state)
        return waypoints
    }
}

private extension RouteGeocodingService {
    func placeFromMapData(_ query: RouteGeocodingQuery,
                          after previous: CLLocation?,
                          miles: Double,
                          in state: String?) async -> MapCoordinate? {
        let place = PlaceQuery(
            place: query.place,
            hint: query.hint.map { MapCoordinate(lat: $0.latitude, lon: $0.longitude) },
            isStateLine: query.isStateLine,
            miles: miles,
            previous: previous.map { MapCoordinate(lat: $0.coordinate.latitude, lon: $0.coordinate.longitude) })
        let response = try? await networkService.request(
            .places(request: PlacesRequest(state: state, places: [place])),
            responseModel: PlacesResponse.self)
        return response?.places.first?.coordinate
    }

    func findStart(of waypoints: inout [RouteWaypoint], queries: [RouteGeocodingQuery], in state: String?) async {
        guard let start = queries.first, waypoints.first?.isResolved == false,
              let next = waypoints.indices.dropFirst().first(where: { waypoints[$0].isResolved }),
              let latitude = waypoints[next].latitude, let longitude = waypoints[next].longitude,
              let road = roadNumber(of: start.place) else { return }

        let anchor = CLLocation(latitude: latitude, longitude: longitude)
        let miles = queries[1...next].reduce(0) { $0 + $1.miles }
        let maxDistance: Double
        if miles > 0 {
            maxDistance = miles * DistanceConstants.metersPerMile * Constants.startSlackRatio
                + Constants.startSlackMeters
        } else if let startHint = start.hint.map(location), let nextHint = queries[next].hint.map(location) {
            maxDistance = startHint.distance(from: nextHint) * Constants.startSlackRatio + Constants.startSlackMeters
            guard maxDistance <= Constants.startReachMeters else { return }
        } else {
            return
        }
        let area = region(around: anchor.coordinate, meters: maxDistance)

        var nearest: CLLocationCoordinate2D?
        for wording in [start.place] + wordings(of: roads(of: start.place)) {
            for match in await search(wording, in: area)
            where isAllowed(match, for: start, in: state) && mentions(road, in: match.text) {
                let distance = location(match.coordinate).distance(from: anchor)
                if distance <= maxDistance, nearest.map({ distance < location($0).distance(from: anchor) }) ?? true {
                    nearest = match.coordinate
                }
            }
            if nearest != nil {
                break
            }
        }
        waypoints[0].latitude = nearest?.latitude
        waypoints[0].longitude = nearest?.longitude
    }

    func dropStateLineEndsOnWrongSide(in waypoints: inout [RouteWaypoint],
                                      queries: [RouteGeocodingQuery],
                                      state: String?) {
        guard waypoints.count >= 2 else { return }
        for index in [waypoints.startIndex, waypoints.endIndex - 1] where queries.indices.contains(index) {
            guard queries[index].isStateLine,
                  let end = coordinate(of: waypoints[index]),
                  let neighbor = neighborStateCenter(in: queries[index].place, excluding: state) else { continue }
            let others = index == waypoints.startIndex
                ? Array(waypoints.dropFirst())
                : Array(waypoints.dropLast().reversed())
            guard let anchor = others.lazy.compactMap(coordinate(of:)).first else { continue }
            let towardEnd = bearing(from: anchor, to: end)
            let towardState = bearing(from: anchor, to: neighbor)
            if angle(between: towardEnd, and: towardState) > Constants.maxStateLineAngle {
                waypoints[index].latitude = nil
                waypoints[index].longitude = nil
            }
        }
    }

    func neighborStateCenter(in place: String, excluding state: String?) -> CLLocationCoordinate2D? {
        let road = roads(of: place).uppercased()
        let own = state?.uppercased()
        for center in StateCenter.all.sorted(by: { $0.name.count > $1.name.count }) where center.code != own {
            let named = road.contains(center.name)
            let words = road.split(whereSeparator: { !$0.isLetter }).map(String.init)
            let coded = words.contains(center.code) && words.contains("LINE")
            if named || coded {
                return CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
            }
        }
        return nil
    }

    func coordinate(of waypoint: RouteWaypoint) -> CLLocationCoordinate2D? {
        guard let latitude = waypoint.latitude, let longitude = waypoint.longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func bearing(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> Double {
        let east = (end.longitude - start.longitude) * cos(start.latitude * .pi / 180)
        let north = end.latitude - start.latitude
        return (atan2(east, north) * 180 / .pi + 360).truncatingRemainder(dividingBy: 360)
    }

    func angle(between first: Double, and second: Double) -> Double {
        let difference = abs(first - second).truncatingRemainder(dividingBy: 360)
        return min(difference, 360 - difference)
    }

    func dropStartOnTopOfNext(in waypoints: inout [RouteWaypoint]) {
        guard let start = waypoints.first, let startLatitude = start.latitude, let startLongitude = start.longitude,
              let next = waypoints.dropFirst().first(where: \.isResolved),
              let nextLatitude = next.latitude, let nextLongitude = next.longitude else { return }
        let distance = CLLocation(latitude: startLatitude, longitude: startLongitude)
            .distance(from: CLLocation(latitude: nextLatitude, longitude: nextLongitude))
        if distance < Constants.startOnTopOfNextMeters {
            waypoints[0].latitude = nil
            waypoints[0].longitude = nil
        }
    }

    func roadNumber(of place: String) -> String? {
        let firstRoad = roads(of: place).components(separatedBy: " & ").first ?? place
        return firstRoad.firstMatch(of: /\d+/).map { String($0.output) }
    }

    func mentions(_ number: String, in text: String) -> Bool {
        text.matches(of: /\d+/).contains { $0.output == number }
    }

    func isAllowed(_ match: MapMatch, for query: RouteGeocodingQuery, in state: String?) -> Bool {
        guard let state, let matchState = match.state,
              matchState.uppercased() != state.uppercased() else { return true }
        guard query.isStateLine, let road = roadKey(of: query.place) else { return false }
        return roadKeys(in: match.text).contains(road)
    }

    func roadKey(of place: String) -> String? {
        roadKeys(in: roads(of: place).components(separatedBy: " & ").first ?? place).first
    }

    func roadKeys(in text: String) -> [String] {
        let pattern = /\b(?:(I|IH|INTERSTATE)|(US))[\s-]*0*(\d+)/
        return text.uppercased().matches(of: pattern).map { match in
            (match.output.1 != nil ? "I" : "US") + match.output.3
        }
    }

    func acceptRadius(at index: Int, in queries: [RouteGeocodingQuery]) -> Double {
        guard let hint = queries[index].hint.map(location) else { return Constants.hintRadiusMeters }
        let neighbors = [index - 1, index + 1]
            .filter(queries.indices.contains)
            .compactMap { queries[$0].hint.map(location) }
        guard let spacing = neighbors.map({ $0.distance(from: hint) }).min() else { return Constants.hintRadiusMeters }
        let radius = max(spacing * Constants.spacingRadiusFactor, Constants.minimumAcceptRadiusMeters)
        return min(radius, Constants.hintRadiusMeters)
    }

    func coordinate(of place: String,
                    near hint: RouteGeocodingHint,
                    within radius: Double,
                    accepts: (MapMatch) -> Bool) async -> CLLocationCoordinate2D? {
        let center = location(hint)
        let area = region(around: center.coordinate, meters: radius)
        let distance = { (coordinate: CLLocationCoordinate2D) in self.location(coordinate).distance(from: center) }

        var nearest: CLLocationCoordinate2D?
        for wording in wordings(of: roads(of: place)) {
            let matches = await search(wording, in: area).filter(accepts).map(\.coordinate)
            for candidate in matches where distance(candidate) <= radius {
                if nearest.map({ distance(candidate) < distance($0) }) ?? true {
                    nearest = candidate
                }
            }
            if let nearest, distance(nearest) <= Constants.closeEnoughMeters {
                break
            }
        }
        return nearest
    }

    func wordings(of roads: String) -> [String] {
        let parts = roads.components(separatedBy: " & ")
        let swapped = parts.count == 2 ? ["\(parts[1]) & \(parts[0])"] : []
        return [roads] + swapped + ["\(roads) interchange"]
    }

    func roads(of place: String) -> String {
        place.split(separator: ",").first.map(String.init) ?? place
    }

    func coordinate(of place: String,
                    after previous: CLLocation?,
                    miles: Double,
                    accepts: (MapMatch) -> Bool) async -> CLLocationCoordinate2D? {
        let roadMeters = miles * DistanceConstants.metersPerMile
        let nearby = previous.map {
            region(around: $0.coordinate, meters: max(roadMeters, Constants.minimumSearchMeters))
        }
        var candidates = await search(place, in: nearby).filter(accepts).map(\.coordinate)
        guard let previous, miles > 0 else { return candidates.first }

        let ratio = { (coordinate: CLLocationCoordinate2D) in
            previous.distance(from: location(coordinate)) / roadMeters
        }
        let best = {
            candidates.min {
                abs(ratio($0) - Constants.straightLineRatio) < abs(ratio($1) - Constants.straightLineRatio)
            }
        }

        if let match = best(), Constants.likelyRatio.contains(ratio(match)) {
            return match
        }
        let roads = roads(of: place)
        let distance = roadMeters * Constants.straightLineRatio
        for bearing in Constants.searchBearings {
            let center = offset(previous.coordinate, meters: distance, bearing: bearing)
            candidates += await search(roads, in: region(around: center, meters: distance))
                .filter(accepts)
                .map(\.coordinate)
        }
        return best().flatMap { Constants.acceptedRatio.contains(ratio($0)) ? $0 : nil }
    }

    func search(_ place: String, in region: MKCoordinateRegion?) async -> [MapMatch] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = place
        request.resultTypes = [.address, .pointOfInterest]
        if let region {
            request.region = region
        }
        for attempt in 0...Constants.throttleRetries {
            do {
                return try await MKLocalSearch(request: request).start().mapItems.map { match(from: $0) }
            } catch let error as MKError where error.code == .loadingThrottled && attempt < Constants.throttleRetries {
                try? await Task.sleep(for: Constants.throttleWait)
            } catch {
                return []
            }
        }
        return []
    }

    func region(around center: CLLocationCoordinate2D, meters: Double) -> MKCoordinateRegion {
        MKCoordinateRegion(center: center, latitudinalMeters: meters * 2, longitudinalMeters: meters * 2)
    }

    func offset(_ coordinate: CLLocationCoordinate2D, meters: Double, bearing: Double) -> CLLocationCoordinate2D {
        let radians = bearing * .pi / 180
        let latitude = coordinate.latitude + meters * cos(radians) / DistanceConstants.metersPerDegree
        let longitude = coordinate.longitude
            + meters * sin(radians) / (DistanceConstants.metersPerDegree * cos(coordinate.latitude * .pi / 180))
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func match(from mapItem: MKMapItem) -> MapMatch {
        if #available(iOS 26, *) {
            let address = mapItem.addressRepresentations?.fullAddress(includingRegion: false, singleLine: true) ?? ""
            let state = address.firstMatch(of: /,\s*([A-Z]{2})\s+\d{5}/).map { String($0.output.1) }
                ?? mapItem.addressRepresentations?.cityWithContext(.short)?
                    .split(separator: ",").last?.trimmingCharacters(in: .whitespaces).nilIfEmpty
            let text = [mapItem.name, mapItem.address?.shortAddress].compactMap(\.self).joined(separator: ", ")
            return MapMatch(coordinate: mapItem.location.coordinate, state: state, text: text)
        }
        let placemark = mapItem.placemark
        let text = [mapItem.name, placemark.thoroughfare].compactMap(\.self).joined(separator: ", ")
        return MapMatch(coordinate: placemark.coordinate, state: placemark.administrativeArea, text: text)
    }

    func location(_ hint: RouteGeocodingHint) -> CLLocation {
        CLLocation(latitude: hint.latitude, longitude: hint.longitude)
    }

    func location(_ coordinate: CLLocationCoordinate2D) -> CLLocation {
        CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

private extension RouteGeocodingService {
    enum Constants {
        static let minimumSearchMeters = 16_000.0
        static let straightLineRatio = 0.85
        static let likelyRatio = 0.6...1.4
        static let acceptedRatio = 0.3...1.6
        static let searchBearings: [Double] = [0, 90, 180, 270]
        static let hintRadiusMeters = 25_000.0
        static let minimumAcceptRadiusMeters = 3_000.0
        static let spacingRadiusFactor = 1.5
        static let throttleRetries = 6
        static let throttleWait = Duration.seconds(10)
        static let closeEnoughMeters = 3_000.0
        static let startSlackRatio = 1.1
        static let startSlackMeters = 5_000.0
        static let startReachMeters = 30_000.0
        static let startOnTopOfNextMeters = 2_000.0
        static let maxStateLineAngle = 100.0
    }
}
