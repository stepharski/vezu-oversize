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

private enum Design {
    static let spacing: CGFloat = 8
    static let rowSpacing: CGFloat = 14
    static let padding: CGFloat = 16
    static let titleTracking: CGFloat = 1
    static let titleIndent: CGFloat = 4
}
