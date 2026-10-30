import SwiftUI

struct RouteDetailView: View {
    @State var viewModel: RouteDetailViewModel

    var body: some View {
        ZStack {
            AppBackgroundView()
            content
        }
        .navigationTitle(AppText.PermitBrief.route)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if viewModel.canNavigate {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(AppText.PermitBrief.navigate, systemImage: "square.and.arrow.up") {
                        viewModel.didTapNavigate()
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isNavigationPresented) {
            RouteNavigationSheet(
                waypoints: viewModel.waypoints,
                unresolvedCount: viewModel.unresolvedCount,
                mapsLinks: viewModel.mapsLinks)
        }
        .task {
            await viewModel.load()
        }
    }
}

private extension RouteDetailView {
    var route: PermitRoute {
        viewModel.route
    }

    var content: some View {
        ScrollView {
            LazyVStack(spacing: Design.cellSpacing) {
                RouteOverviewCell(route: route)

                if !route.prohibitedRoads.isEmpty {
                    ProhibitedRoadsCell(roads: route.prohibitedRoads)
                }

                detailStatus
                RouteDirectionsCell(route: route)
            }
            .padding(.horizontal, Design.horizontalPadding)
            .padding(.vertical, Design.verticalPadding)
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    var detailStatus: some View {
        switch viewModel.detailState {
        case .loading:
            HStack(spacing: Design.statusSpacing) {
                ProgressView()
                Text(AppText.PermitBrief.preparingNavigation)
                    .foregroundStyle(Color.secondaryGray)
            }
            .font(.subheadline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardStyle()
        case .failed(let message):
            VStack(alignment: .leading, spacing: Design.statusSpacing) {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryGray)

                Button(AppText.PermitBrief.retry, systemImage: "arrow.clockwise") {
                    Task { await viewModel.load() }
                }
                .font(.subheadline.weight(.semibold))
                .tint(Color.primaryYellow)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardStyle()
        case .ready, .unavailable:
            EmptyView()
        }
    }
}

private extension RouteDetailView {
    enum Design {
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 8
        static let cellSpacing: CGFloat = 12
        static let statusSpacing: CGFloat = 10
    }
}
