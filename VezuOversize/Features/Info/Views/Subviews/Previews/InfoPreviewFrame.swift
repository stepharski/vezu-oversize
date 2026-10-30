import SwiftUI

struct InfoPreviewFrame<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(Design.padding)
            .frame(maxWidth: .infinity)
            .background { background }
            .clipShape(.rect(cornerRadius: Design.cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: Design.cornerRadius)
                    .stroke(Color.dividerGray, lineWidth: 1)
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

private extension InfoPreviewFrame {
    var background: some View {
        ZStack(alignment: .topTrailing) {
            Color.nearBlack

            Circle()
                .fill(Color.yellowGlow.opacity(0.5))
                .frame(width: Design.glowSize)
                .blur(radius: Design.glowBlur)
                .offset(x: Design.glowOffset, y: -Design.glowOffset)
        }
    }
}

private enum Design {
    static let padding: CGFloat = 16
    static let cornerRadius: CGFloat = 24
    static let glowSize: CGFloat = 140
    static let glowBlur: CGFloat = 70
    static let glowOffset: CGFloat = 50
}
