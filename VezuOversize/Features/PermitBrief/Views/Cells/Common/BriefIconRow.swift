import SwiftUI

struct BriefIconRow: View {
    let systemImage: String
    let title: String
    var detail: String?
    var detailColor: Color = .secondaryGray

    var body: some View {
        HStack(alignment: .top, spacing: Design.spacing) {
            iconBox
            texts
        }
    }
}

// MARK: - Components
private extension BriefIconRow {
    var iconBox: some View {
        Image(systemName: systemImage)
            .font(.body)
            .foregroundStyle(Color.primaryYellow)
            .frame(width: Design.iconBoxSize, height: Design.iconBoxSize)
            .background(
                Color.darkAmber.opacity(0.35),
                in: .rect(cornerRadius: Design.iconBoxCornerRadius)
            )
    }

    var texts: some View {
        VStack(alignment: .leading, spacing: Design.textSpacing) {
            Text(title)
                .font(.body.weight(.semibold))
                .foregroundStyle(Color.primaryWhite)

            if let detail {
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(detailColor)
            }
        }
        .frame(minHeight: Design.iconBoxSize)
    }
}

// MARK: - Design
private enum Design {
    static let spacing: CGFloat = 12
    static let textSpacing: CGFloat = 2
    static let iconBoxSize: CGFloat = 36
    static let iconBoxCornerRadius: CGFloat = 10
}
