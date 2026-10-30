import SwiftUI

struct RouteNavigationSheet: View {
    let waypoints: [RouteWaypoint]
    let unresolvedCount: Int
    let mapsLinks: [URL]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.sheetGray
                    .ignoresSafeArea()
                content
            }
            .navigationTitle(AppText.PermitBrief.navigate)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(AppText.Common.cancel) { dismiss() }
                }
            }
        }
        .presentationDetents([.large])
        .presentationBackground(Color.sheetGray)
    }
}

private extension RouteNavigationSheet {
    var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Design.spacing) {
                warning

                BriefSectionCell(title: AppText.PermitBrief.waypoints(routeWaypointCount)) {
                    VStack(alignment: .leading, spacing: Design.rowSpacing) {
                        if let start = waypoints.first, !start.isResolved {
                            currentLocationRow(start)
                        }

                        ForEach(listedWaypoints, id: \.waypoint.id) { item in
                            waypointRow(item.waypoint, number: item.number)
                        }
                    }
                }

                if unresolvedCount > 0 {
                    Text(AppText.PermitBrief.unresolvedWaypoints(unresolvedCount))
                        .font(.footnote)
                        .foregroundStyle(Color.secondaryGray)
                }

                if mapsLinks.count > 1 {
                    Text(AppText.PermitBrief.mapsParts(mapsLinks.count))
                        .font(.footnote)
                        .foregroundStyle(Color.secondaryGray)
                }
            }
            .padding(.horizontal, Design.horizontalPadding)
            .padding(.vertical, Design.verticalPadding)
        }
        .safeAreaInset(edge: .bottom) {
            actions
        }
        .scrollIndicators(.hidden)
    }

    var routeWaypointCount: Int {
        waypoints.filter(\.isResolved).count
    }

    var listedWaypoints: [(waypoint: RouteWaypoint, number: Int?)] {
        let listed = waypoints.first?.isResolved == false ? Array(waypoints.dropFirst()) : waypoints
        var number = 0
        return listed.map { waypoint in
            guard waypoint.isResolved else { return (waypoint, nil) }
            number += 1
            return (waypoint, number)
        }
    }

    var actions: some View {
        VStack(spacing: Design.actionSpacing) {
            ForEach(Array(mapsLinks.enumerated()), id: \.offset) { index, link in
                Link(destination: link) {
                    Label(openTitle(part: index + 1), systemImage: "map.fill")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Color.nearBlack)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Design.buttonPadding)
                        .background(Color.primaryYellow, in: .capsule)
                }
            }
        }
        .padding(.horizontal, Design.horizontalPadding)
        .padding(.top, Design.buttonTopPadding)
        .padding(.bottom, Design.buttonBottomPadding)
        .background(Color.sheetGray)
    }

    func openTitle(part: Int) -> String {
        mapsLinks.count == 1
            ? AppText.PermitBrief.openInGoogleMaps
            : AppText.PermitBrief.openPart(part, of: mapsLinks.count)
    }

    var warning: some View {
        HStack(alignment: .top, spacing: Design.rowSpacing) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title3)
                .foregroundStyle(Color.primaryYellow)

            VStack(alignment: .leading, spacing: Design.warningSpacing) {
                Text(AppText.PermitBrief.navigationRiskTitle)
                    .font(.headline)
                    .foregroundStyle(Color.primaryWhite)

                Text(AppText.PermitBrief.navigationRiskMessage)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryGray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
        .overlay {
            RoundedRectangle(cornerRadius: Design.warningCornerRadius)
                .stroke(Color.primaryYellow.opacity(0.4), lineWidth: 1)
        }
    }

    func currentLocationRow(_ start: RouteWaypoint) -> some View {
        HStack(spacing: Design.rowSpacing) {
            Image(systemName: "location.fill")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.primaryYellow)
                .frame(width: Design.badgeSize, height: Design.badgeSize)
                .background(Color.darkAmber.opacity(0.35), in: .circle)

            VStack(alignment: .leading, spacing: Design.textSpacing) {
                Text(AppText.PermitBrief.startsFromYourLocation)
                    .font(.subheadline)
                    .foregroundStyle(Color.primaryWhite)

                Text(AppText.PermitBrief.driveToStartFirst(start.name))
                    .font(.footnote)
                    .foregroundStyle(Color.secondaryGray)
            }
        }
    }

    func waypointRow(_ waypoint: RouteWaypoint, number: Int?) -> some View {
        HStack(spacing: Design.rowSpacing) {
            Group {
                if let number {
                    Text("\(number)")
                        .font(.footnote.weight(.bold))
                        .foregroundStyle(Color.primaryYellow)
                } else {
                    Image(systemName: "mappin.slash")
                        .font(.caption)
                        .foregroundStyle(Color.secondaryGray)
                }
            }
            .frame(width: Design.badgeSize, height: Design.badgeSize)
            .background(Color.darkAmber.opacity(number == nil ? 0.15 : 0.35), in: .circle)

            Text(waypoint.name)
                .font(.subheadline)
                .foregroundStyle(waypoint.isResolved ? Color.primaryWhite : Color.secondaryGray)
                .strikethrough(!waypoint.isResolved)
        }
    }
}

private extension RouteNavigationSheet {
    enum Design {
        static let spacing: CGFloat = 12
        static let rowSpacing: CGFloat = 12
        static let badgeSize: CGFloat = 24
        static let textSpacing: CGFloat = 2
        static let warningSpacing: CGFloat = 6
        static let warningCornerRadius: CGFloat = 20
        static let buttonPadding: CGFloat = 14
        static let actionSpacing: CGFloat = 10
        static let buttonTopPadding: CGFloat = 12
        static let buttonBottomPadding: CGFloat = 8
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 16
    }
}
