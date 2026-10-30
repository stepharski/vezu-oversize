import SwiftUI

struct AppBackgroundView: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.nearBlack
            glow
        }
        .ignoresSafeArea()
    }
}

private extension AppBackgroundView {
    var glow: some View {
        Circle()
            .fill(Color.yellowGlow)
            .frame(width: Design.circleSize)
            .blur(radius: Design.blurRadius)
            .offset(x: Design.offset, y: -Design.offset)
    }
}

private extension AppBackgroundView {
    enum Design {
        static let offset: CGFloat = 75
        static let circleSize: CGFloat = 200
        static let blurRadius: CGFloat = 100
    }
}
