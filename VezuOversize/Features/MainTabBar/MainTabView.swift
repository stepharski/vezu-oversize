import SwiftUI

struct MainTabView: View {
    let permitManager: PermitManager
    let importManager: ImportManager
    @Bindable var consentManager: AIConsentManager
    @State private var selectedTab = AppTab.permits

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(AppTab.permits.title, systemImage: AppTab.permits.imageName, value: .permits) {
                PermitsView(
                    viewModel: PermitsViewModel(
                        permitManager: permitManager,
                        importManager: importManager,
                        consentManager: consentManager))
            }

            Tab(AppTab.info.title, systemImage: AppTab.info.imageName, value: .info) {
                InfoView(
                    viewModel: InfoViewModel(
                        permitManager: permitManager,
                        importManager: importManager))
            }
        }
        .tint(.primaryYellow)
        .onOpenURL(perform: openSharedPDF)
        .sheet(isPresented: $consentManager.isPromptPresented, onDismiss: consentManager.promptDismissed) {
            AIConsentSheet(onAgree: consentManager.didTapAgree, onDecline: consentManager.didTapDecline)
        }
    }
}

private extension MainTabView {
    func openSharedPDF(_ url: URL) {
        selectedTab = .permits
        consentManager.requestConsent {
            Task { await importManager.importSharedPDF(at: url) }
        }
    }
}
