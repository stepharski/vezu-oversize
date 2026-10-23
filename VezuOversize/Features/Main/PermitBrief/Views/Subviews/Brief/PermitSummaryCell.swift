import SwiftUI

struct PermitSummaryCell: View {
    let permitType: String
    let number: String
    let dateRangeText: String
    let status: PermitStatus

    var body: some View {
        VStack(alignment: .leading, spacing: Design.spacing) {
            header
            numberLabel
            dateLabel
                .padding(.top, Design.dateTopPadding)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

private extension PermitSummaryCell {
    var header: some View {
        HStack {
            Text(permitType)
                .font(.body)
                .foregroundStyle(Color.secondaryGray)

            Spacer(minLength: Design.spacerSize)

            PermitStatusBadge(status: status)
        }
    }

    var numberLabel: some View {
        Text(number)
            .font(.title2.bold())
            .foregroundStyle(Color.primaryWhite)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
    }

    var dateLabel: some View {
        Label(dateRangeText, systemImage: "calendar")
            .font(.body)
            .foregroundStyle(Color.secondaryGray)
            .lineLimit(1)
    }
}

private enum Design {
    static let spacing: CGFloat = 4
    static let spacerSize: CGFloat = 8
    static let dateTopPadding: CGFloat = 8
}
