import SwiftUI

struct PermitsView: View {
    @State private var viewModel = PermitsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                content
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $viewModel.selectedBrief) { brief in
                PermitBriefView(viewModel: PermitBriefViewModel(brief: brief))
            }
        }
    }
}

// MARK: - Components
private extension PermitsView {
    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            if viewModel.isEmpty {
                PermitsEmptyStateView(onTryDemo: viewModel.tryDemoTapped)
            } else {
                filterPicker
                    .padding(.top, Design.sectionSpacing)
                permitsList
            }
        }
        .animation(.snappy, value: viewModel.isEmpty)
    }

    var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: Design.headerSpacing) {
                Text(AppText.Permits.title)
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.primaryWhite)

                Text(AppText.Permits.subtitle)
                    .font(.headline)
                    .foregroundStyle(Color.secondaryGray)
            }
            Spacer()
            importButton
                .padding(.top, Design.importButtonTopPadding)
        }
        .padding(.top, Design.topPadding)
        .padding(.horizontal, Design.xPadding)
    }

    var importButton: some View {
        Button(action: viewModel.importTapped) {
            Label(AppText.Permits.importTitle, systemImage: "square.and.arrow.up")
                .font(.headline)
                .foregroundStyle(Color.primaryYellow)
                .padding(.horizontal, Design.importButtonXPadding)
                .padding(.vertical, Design.importButtonYPadding)
                .background(Color.nearBlack.opacity(0.5), in: .capsule)
                .overlay {
                    Capsule()
                        .stroke(Color.primaryYellow.opacity(0.5), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }

    var filterPicker: some View {
        PermitsFilterPicker(selection: $viewModel.selectedFilter) { filter in
            viewModel.count(for: filter)
        }
        .padding(.horizontal, Design.xPadding)
    }

    var permitsList: some View {
        List {
            ForEach(viewModel.filteredPermits) { permit in
                permitRow(permit)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .contentMargins(.top, Design.sectionSpacing, for: .scrollContent)
        .mask { topFadeMask }
        .animation(.snappy, value: viewModel.selectedFilter)
    }

    var topFadeMask: some View {
        VStack(spacing: 0) {
            LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                .frame(height: Design.sectionSpacing)

            Rectangle()
                .ignoresSafeArea(edges: .bottom)
        }
    }

    func permitRow(_ permit: Permit) -> some View {
        Button {
            viewModel.select(permit)
        } label: {
            PermitRowView(permit: permit)
        }
        .buttonStyle(.plain)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(
            EdgeInsets(
                top: Design.rowSpacing / 2,
                leading: Design.xPadding,
                bottom: Design.rowSpacing / 2,
                trailing: Design.xPadding
            )
        )
    }
}

// MARK: - Design
private enum Design {
    static let xPadding: CGFloat = 16
    static let topPadding: CGFloat = 24
    static let sectionSpacing: CGFloat = 22
    static let headerSpacing: CGFloat = 8
    static let rowSpacing: CGFloat = 12

    static let importButtonTopPadding: CGFloat = 4
    static let importButtonXPadding: CGFloat = 18
    static let importButtonYPadding: CGFloat = 12
}

#Preview {
    PermitsView()
}
