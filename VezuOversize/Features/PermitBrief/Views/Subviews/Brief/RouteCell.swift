import SwiftUI
import SwiftUIPocketKit

struct RouteCell: View {
    let route: PermitRoute
    let onTap: CompletionBlock

    var body: some View {
        Button(action: onTap) {
            BriefSectionCell(
                title: AppText.PermitBrief.route,
                systemImage: "point.topleft.down.to.point.bottomright.curvepath",
                showsChevron: true) {
                    summary
                }
            .contentShape(.rect(cornerRadius: Design.cornerRadius))
        }
        .buttonStyle(.plain)
    }
}

private extension RouteCell {
    var summary: some View {
        VStack(alignment: .leading, spacing: Design.textSpacing) {
            Text("\(route.origin) → \(route.destination)")
                .font(.body.weight(.semibold))
                .foregroundStyle(Color.primaryWhite)

            if route.totalMiles > 0 {
                Text(route.totalMiles.milesText)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryGray)
            }
        }
    }
}

private extension RouteCell {
    enum Design {
        static let textSpacing: CGFloat = 2
        static let cornerRadius: CGFloat = 20
    }
}
