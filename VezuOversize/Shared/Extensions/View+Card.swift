import SwiftUI

extension View {
    func cardStyle(padding: CGFloat = 20, cornerRadius: CGFloat = 20) -> some View {
        self
            .padding(padding)
            .background(
                Color.cardBlack.opacity(0.9),
                in: .rect(cornerRadius: cornerRadius)
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.dividerGray.opacity(0.6), lineWidth: 1)
            }
    }
}
