import SwiftUI

struct BriefItemRow: View {
    let item: PermitBrief.Item
    let systemImage: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: Design.iconSpacing) {
            icon
            texts
        }
    }
}

// MARK: - Components
private extension BriefItemRow {
    var icon: some View {
        Image(systemName: systemImage)
            .foregroundStyle(Color.primaryYellow)
    }

    var texts: some View {
        VStack(alignment: .leading, spacing: Design.textSpacing) {
            Text(item.title)
                .font(.body.weight(.semibold))
                .foregroundStyle(Color.primaryWhite)

            if let detail = item.detail {
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryGray)
            }
        }
    }
}

// MARK: - Design
private enum Design {
    static let iconSpacing: CGFloat = 10
    static let textSpacing: CGFloat = 2
}
