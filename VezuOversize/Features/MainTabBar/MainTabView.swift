import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab(AppText.Tabs.permits, systemImage: "doc.text.fill") {
                PermitsView()
            }

            Tab(AppText.Tabs.info, systemImage: "info.circle") {
                InfoView()
            }
        }
        .tint(.primaryYellow)
        .preferredColorScheme(.dark)
    }
}
