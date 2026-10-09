import SwiftUI

struct AppBackgroundView: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.nearBlack

            Circle()
                .fill(Color.yellowGlow)
                .frame(width: Design.circleSize)
                .blur(radius: Design.blurRadius)
                .offset(x: Design.offset, y: -Design.offset)
        }
        .ignoresSafeArea()
    }
}

private enum Design {
    static let offset: CGFloat = 75
    static let circleSize: CGFloat = 200
    static let blurRadius: CGFloat = 100
}

#Preview {
    AppBackgroundView()
}
