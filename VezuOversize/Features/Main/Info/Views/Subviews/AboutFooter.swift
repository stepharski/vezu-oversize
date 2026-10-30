import SwiftUI

struct AboutFooter: View {
    let versionText: String

    var body: some View {
        VStack(spacing: Design.spacing) {
            Text(versionText)
                .foregroundStyle(Color.primaryWhite.opacity(0.85))

            Link(AppText.Info.mapDataCredit, destination: Design.openStreetMapCopyright)
            Text(AppText.Info.stateBordersCredit)
            Text(AppText.Info.copyright)
        }
        .font(.footnote)
        .foregroundStyle(Color.secondaryGray)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }
}

private enum Design {
    static let spacing: CGFloat = 6
    static let openStreetMapCopyright = URL(string: "https://www.openstreetmap.org/copyright")!
}
