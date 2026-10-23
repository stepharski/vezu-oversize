import SwiftUI

struct InfoView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            AppBackgroundView()
            title
        }
    }
}

private extension InfoView {
    var title: some View {
        Text(AppTab.info.title)
            .font(.largeTitle.bold())
            .foregroundStyle(Color.primaryWhite)
            .padding(.horizontal, Design.horizontalPadding)
            .padding(.top, Design.topPadding)
    }
}

private enum Design {
    static let horizontalPadding: CGFloat = 16
    static let topPadding: CGFloat = 24
}
