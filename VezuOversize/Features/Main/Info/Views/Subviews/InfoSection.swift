import SwiftUI

struct InfoSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: Design.spacing) {
            Text(title.uppercased())
                .font(.footnote.weight(.semibold))
                .tracking(Design.titleTracking)
                .foregroundStyle(Color.secondaryGray)
                .padding(.leading, Design.titleIndent)

            VStack(alignment: .leading, spacing: Design.rowSpacing) {
                content
            }
            .cardStyle(padding: Design.padding)
        }
    }
}

struct InfoSectionDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.dividerGray)
            .frame(height: 1)
            .padding(.leading, Design.dividerIndent)
    }
}

private enum Design {
    static let spacing: CGFloat = 8
    static let rowSpacing: CGFloat = 14
    static let padding: CGFloat = 16
    static let titleTracking: CGFloat = 1
    static let titleIndent: CGFloat = 4
    static let dividerIndent: CGFloat = 48
}
