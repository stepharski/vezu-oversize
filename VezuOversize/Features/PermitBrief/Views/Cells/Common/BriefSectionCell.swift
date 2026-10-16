import SwiftUI

struct BriefSectionCell<Content: View>: View {
    let title: String
    var systemImage: String?
    var showsChevron = false
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: Design.spacing) {
            header
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

// MARK: - Components
private extension BriefSectionCell {
    var header: some View {
        HStack(spacing: Design.iconSpacing) {
            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundStyle(Color.primaryYellow)
            }

            Text(title)
                .foregroundStyle(Color.primaryWhite)

            if showsChevron {
                Spacer()
                chevron
            }
        }
        .font(.title3.weight(.semibold))
    }

    var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.body.weight(.semibold))
            .foregroundStyle(Color.secondaryGray)
    }
}

// MARK: - Design
private enum Design {
    static let spacing: CGFloat = 14
    static let iconSpacing: CGFloat = 10
}
