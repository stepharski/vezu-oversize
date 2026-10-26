import SwiftUI

struct PermitFeeCell: View {
    let feeText: String

    var body: some View {
        HStack {
            titleLabel
            Spacer()
            feeLabel
        }
        .cardStyle()
    }
}

private extension PermitFeeCell {
    var titleLabel: some View {
        Label {
            Text(AppText.PermitBrief.permitFee)
                .foregroundStyle(Color.primaryWhite)
        } icon: {
            Image(systemName: "dollarsign.circle")
                .foregroundStyle(Color.primaryYellow)
        }
        .font(.title3.weight(.semibold))
    }

    var feeLabel: some View {
        Text(feeText)
            .font(.headline)
            .foregroundStyle(Color.primaryYellow)
    }
}
