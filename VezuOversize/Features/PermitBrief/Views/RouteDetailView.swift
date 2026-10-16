import SwiftUI

struct RouteDetailView: View {
    let route: PermitBrief.RouteInfo

    var body: some View {
        ZStack {
            AppBackgroundView()
            content
        }
        .navigationTitle(AppText.PermitBrief.route)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Components
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
            .padding(.horizontal, Design.xPadding)
            .padding(.vertical, Design.yPadding)
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - Design
private enum Design {
    static let xPadding: CGFloat = 16
    static let yPadding: CGFloat = 8
    static let cellSpacing: CGFloat = 12
}

#Preview {
    NavigationStack {
        RouteDetailView(route: PermitBrief.demo.route)
    }
}
