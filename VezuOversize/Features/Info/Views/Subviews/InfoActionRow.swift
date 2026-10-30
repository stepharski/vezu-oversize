import SwiftUI
import SwiftUIPocketKit

struct InfoActionRow: View {
    let systemImage: String
    let title: String
    var detail: String?
    var value: String?
    let action: CompletionBlock

    var body: some View {
        Button(action: action) {
            HStack(spacing: Design.spacing) {
                BriefIconRow(systemImage: systemImage, title: title, detail: detail)

                Spacer(minLength: .zero)

                if let value {
                    Text(value)
                        .font(.body)
                        .foregroundStyle(Color.secondaryGray)
                }
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}

private extension InfoActionRow {
    enum Design {
        static let spacing: CGFloat = 8
    }
}
