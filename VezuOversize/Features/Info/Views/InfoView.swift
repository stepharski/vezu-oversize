import SwiftUI

struct InfoView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            AppBackgroundView()
            title
        }
    }
}

// MARK: - Components
private extension InfoView {
    var title: some View {
        Text(AppText.Tabs.info)
            .font(.largeTitle.bold())
            .foregroundStyle(Color.primaryWhite)
            .padding(.horizontal, Design.xPadding)
            .padding(.top, Design.topPadding)
    }
}

// MARK: - Design
private enum Design {
    static let xPadding: CGFloat = 16
    static let topPadding: CGFloat = 24
}

#Preview {
    InfoView()
}
