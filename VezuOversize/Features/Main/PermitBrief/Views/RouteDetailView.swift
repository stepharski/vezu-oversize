import SwiftUI

struct RouteDetailView: View {
    let route: PermitRoute

    var body: some View {
        ZStack {
            AppBackgroundView()
            content
        }
        .navigationTitle(AppText.PermitBrief.route)
        .navigationBarTitleDisplayMode(.large)
    }
}

private extension RouteDetailView {
    var content: some View {
        ScrollView {
            LazyVStack(spacing: Design.cellSpacing) {
                RouteOverviewCell(route: route)

                if !route.prohibitedRoads.isEmpty {
                    ProhibitedRoadsCell(roads: route.prohibitedRoads)
                }

                RouteDirectionsCell(route: route)
            }
            .padding(.horizontal, Design.horizontalPadding)
            .padding(.vertical, Design.verticalPadding)
        }
        .scrollIndicators(.hidden)
    }
}

private enum Design {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 8
    static let cellSpacing: CGFloat = 12
}
