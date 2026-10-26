import SwiftUI

struct InfoView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            AppBackgroundView()
            title
        }
        .overlay(alignment: .bottom) {
            mapDataCredit
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

private extension InfoView {
    var mapDataCredit: some View {
        Link(AppText.Info.mapDataCredit, destination: Design.openStreetMapCopyright)
            .font(.footnote)
            .foregroundStyle(Color.secondaryGray)
            .padding(.horizontal, Design.horizontalPadding)
            .padding(.bottom, Design.creditBottomPadding)
    }
}

private enum Design {
    static let horizontalPadding: CGFloat = 16
    static let topPadding: CGFloat = 24
    static let creditBottomPadding: CGFloat = 110
    static let openStreetMapCopyright = URL(string: "https://www.openstreetmap.org/copyright")!
}
