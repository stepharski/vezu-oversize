import SwiftUI

struct RoutePreview: View {
    var body: some View {
        InfoPreviewFrame {
            VStack(spacing: Design.spacing) {
                RouteCell(route: PermitBrief.demo.route, onTap: {})

                Label(AppText.PermitBrief.openInGoogleMaps, systemImage: "map.fill")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.nearBlack)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Design.buttonPadding)
                    .background(Color.primaryYellow, in: .capsule)
            }
        }
    }
}

private enum Design {
    static let spacing: CGFloat = 14
    static let buttonPadding: CGFloat = 14
}
