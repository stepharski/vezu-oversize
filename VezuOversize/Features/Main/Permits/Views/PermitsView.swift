import SwiftData
import SwiftUI
import UniformTypeIdentifiers
import SwiftUIPocketKit

struct PermitsView: View {
    @State var viewModel: PermitsViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                content
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $viewModel.selectedBrief) { brief in
                PermitBriefView(
                    viewModel: PermitBriefViewModel(
                        brief: brief,
                        permitManager: viewModel.permitManager,
                        importManager: viewModel.importManager))
            }
        }
        .fileImporter(
            isPresented: $viewModel.isFilePickerPresented,
            allowedContentTypes: [.pdf],
            allowsMultipleSelection: true
        ) { result in
            Task { await viewModel.filesPicked(result) }
        }
        .alert(
            AppText.PermitImport.groupingTitle(viewModel.pickedURLs.count),
            isPresented: $viewModel.isGroupingChoicePresented
        ) {
            Button(AppText.PermitImport.onePermit) {
                Task { await viewModel.importAsOnePermit() }
            }
            Button(AppText.PermitImport.separatePermits(viewModel.pickedURLs.count)) {
                Task { await viewModel.importAsSeparatePermits() }
            }
            Button(AppText.Common.cancel, role: .cancel, action: viewModel.cancelGroupingChoice)
        } message: {
            Text(AppText.PermitImport.groupingMessage)
        }
        .alert(viewModel.importManager.errorTitle, isPresented: errorBinding) {
            Button(AppText.Common.ok, action: viewModel.importManager.dismissError)
        } message: {
            Text(viewModel.importManager.errorMessage ?? .empty)
        }
        .onChange(of: viewModel.importManager.lastImportedID) {
            Task { await viewModel.highlightImported() }
        }
    }
}

private extension PermitsView {
    var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.importManager.errorMessage != nil },
            set: { isPresented in
                if !isPresented { viewModel.importManager.dismissError() }
            })
    }
}

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
        .padding(.horizontal, Design.horizontalPadding)
    }

    var importButton: some View {
        Button(action: viewModel.importTapped) {
            Label(AppText.Permits.importTitle, systemImage: "square.and.arrow.up")
                .font(.headline)
                .foregroundStyle(Color.primaryYellow)
                .padding(.horizontal, Design.importButtonHorizontalPadding)
                .padding(.vertical, Design.importButtonVerticalPadding)
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
        .padding(.horizontal, Design.horizontalPadding)
    }

    var permitsList: some View {
        List {
            ForEach(viewModel.pendingImports) { pendingImport in
                pendingImportRow(pendingImport)
            }

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
        .animation(.snappy, value: viewModel.pendingImports)
        .animation(.snappy, value: viewModel.highlightedPermitID)
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
            PermitRowView(
                permit: permit,
                isHighlighted: permit.id == viewModel.highlightedPermitID,
                isReloading: viewModel.isReloading(permit))
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isReloading(permit))
        .swipeActions(edge: .trailing) {
            if !viewModel.isReloading(permit) {
                Button(role: .destructive) {
                    viewModel.delete(permit)
                } label: {
                    Label(AppText.Permits.delete, systemImage: "trash")
                }
                .tint(.red)
            }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(rowInsets)
    }

    func pendingImportRow(_ pendingImport: PendingImport) -> some View {
        PendingImportRow(
            pendingImport: pendingImport,
            onRetry: { Task { await viewModel.retry(pendingImport) } },
            onRemove: { viewModel.remove(pendingImport) })
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(rowInsets)
    }

    var rowInsets: EdgeInsets {
        EdgeInsets(
            top: Design.rowSpacing / 2,
            leading: Design.horizontalPadding,
            bottom: Design.rowSpacing / 2,
            trailing: Design.horizontalPadding)
    }
}

private enum Design {
    static let horizontalPadding: CGFloat = 16
    static let topPadding: CGFloat = 24
    static let sectionSpacing: CGFloat = 22
    static let headerSpacing: CGFloat = 8
    static let rowSpacing: CGFloat = 12

    static let importButtonTopPadding: CGFloat = 4
    static let importButtonHorizontalPadding: CGFloat = 18
    static let importButtonVerticalPadding: CGFloat = 12
}

#Preview {
    let container = try! ModelContainer(
        for: PermitRecord.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let permitManager = PermitManager(context: container.mainContext)

    PermitsView(
        viewModel: PermitsViewModel(
            permitManager: permitManager,
            importManager: ImportManager(permitManager: permitManager)))
}
