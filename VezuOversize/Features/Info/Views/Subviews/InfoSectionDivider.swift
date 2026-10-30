import SwiftUI

struct InfoSectionDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.dividerGray)
            .frame(height: 1)
            .padding(.leading, Design.dividerIndent)
    }
}

private extension InfoSectionDivider {
    enum Design {
        static let dividerIndent: CGFloat = 48
    }
}
