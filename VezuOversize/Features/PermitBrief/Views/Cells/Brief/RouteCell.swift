import SwiftUI

struct RouteCell: View {
    let route: PermitBrief.RouteInfo
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            BriefSectionCell(
                title: AppText.PermitBrief.route,
                systemImage: "point.topleft.down.to.point.bottomright.curvepath",
                showsChevron: true
            ) {
                summary
            }
            .contentShape(.rect(cornerRadius: Design.cornerRadius))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Components
private extension RouteCell {
    var summary: some View {
        VStack(alignment: .leading, spacing: Design.textSpacing) {
            Text("\(route.origin) → \(route.destination)")
                .font(.body.weight(.semibold))
                .foregroundStyle(Color.primaryWhite)

            Text(route.totalMiles.milesText)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryGray)
        }
    }
}

// MARK: - Design
private enum Design {
    static let textSpacing: CGFloat = 2
    static let cornerRadius: CGFloat = 20
}

#Preview {
    RouteCell(route: PermitBrief.demo.route, onTap: {})
        .padding()
        .background(Color.nearBlack)
}
