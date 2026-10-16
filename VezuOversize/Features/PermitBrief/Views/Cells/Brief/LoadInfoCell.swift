import SwiftUI

struct LoadInfoCell: View {
    let load: PermitBrief.LoadInfo

    var body: some View {
        BriefSectionCell(
            title: AppText.PermitBrief.loadInfo,
            systemImage: "shippingbox"
        ) {
            descriptionLabel
            dimensions
            details
        }
    }
}

// MARK: - Components
private extension LoadInfoCell {
    var descriptionLabel: some View {
        Text(load.description)
            .font(.body.weight(.semibold))
            .foregroundStyle(Color.primaryWhite)
    }

    var dimensions: some View {
        HStack(spacing: Design.tileSpacing) {
            dimensionTile(AppText.PermitBrief.height, value: load.height)
            dimensionTile(AppText.PermitBrief.width, value: load.width)
            dimensionTile(AppText.PermitBrief.length, value: load.length)
        }
    }

    @ViewBuilder
    var details: some View {
        if let grossWeight = load.grossWeight {
            BriefInfoRow(title: AppText.PermitBrief.grossWeight, value: grossWeight)
        }

        if let axles = load.axles {
            BriefInfoRow(title: AppText.PermitBrief.axles, value: "\(axles)")
        }
    }

    func dimensionTile(_ title: String, value: String) -> some View {
        VStack(spacing: Design.tileTextSpacing) {
            Text(title)
                .font(.caption.weight(.medium))
                .foregroundStyle(Color.secondaryGray)
                .textCase(.uppercase)

            Text(value)
                .font(.title3.bold())
                .foregroundStyle(Color.primaryWhite)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Design.tileYPadding)
        .background(
            Color.white.opacity(0.06),
            in: .rect(cornerRadius: Design.tileCornerRadius)
        )
    }
}

// MARK: - Design
private enum Design {
    static let tileSpacing: CGFloat = 8
    static let tileTextSpacing: CGFloat = 4
    static let tileYPadding: CGFloat = 12
    static let tileCornerRadius: CGFloat = 12
}

#Preview {
    LoadInfoCell(load: PermitBrief.demo.load)
        .padding()
        .background(Color.nearBlack)
}
