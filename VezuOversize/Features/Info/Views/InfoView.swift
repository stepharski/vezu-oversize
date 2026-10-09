import SwiftUI

struct InfoView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            AppBackgroundView()

            Text("Info")
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(Color.primaryWhite)
                .padding(.horizontal, 20)
                .padding(.top, 24)
        }
    }
}

#Preview {
    InfoView()
}
