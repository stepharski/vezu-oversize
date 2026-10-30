import SwiftUI

struct MainTabView: View {
    let permitManager: PermitManager
    let importManager: ImportManager
    @State private var selectedTab = AppTab.permits

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(AppTab.permits.title, systemImage: AppTab.permits.imageName, value: .permits) {
                PermitsView(
                    viewModel: PermitsViewModel(
                        permitManager: permitManager,
                        importManager: importManager))
            }

            Tab(AppTab.info.title, systemImage: AppTab.info.imageName, value: .info) {
                InfoView(
                    viewModel: InfoViewModel(
                        permitManager: permitManager,
                        importManager: importManager))
            }
        }
        .tint(.primaryYellow)
        .preferredColorScheme(.dark)
        .onOpenURL(perform: openSharedPDF)
    }
}

private extension MainTabView {
    func openSharedPDF(_ url: URL) {
        selectedTab = .permits
        Task { await importManager.importSharedPDF(at: url) }
    }
}
