import SwiftUI

struct BriefInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            titleLabel
            Spacer(minLength: Design.spacerSize)
            valueLabel
        }
        .font(.body)
    }
}

// MARK: - Components
private extension BriefInfoRow {
    var titleLabel: some View {
        Text(title)
            .foregroundStyle(Color.secondaryGray)
    }

    var valueLabel: some View {
        Text(value)
            .foregroundStyle(Color.primaryWhite)
            .multilineTextAlignment(.trailing)
    }
}

// MARK: - Design
private enum Design {
    static let spacerSize: CGFloat = 12
}
