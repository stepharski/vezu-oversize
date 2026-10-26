import SwiftUI

struct AlertsCell: View {
    let alerts: [PermitBriefItem]

    var body: some View {
        BriefSectionCell(
            title: AppText.PermitBrief.alerts,
            systemImage: "exclamationmark.octagon"
        ) {
            alertsList
        }
        .overlay { highlightBorder }
    }
}

private extension AlertsCell {
    var alertsList: some View {
        VStack(alignment: .leading, spacing: Design.rowSpacing) {
            ForEach(alerts) { alert in
                BriefItemRow(item: alert, systemImage: "circle.fill")
                    .imageScale(.small)
            }
        }
    }

    var highlightBorder: some View {
        RoundedRectangle(cornerRadius: Design.cornerRadius)
            .stroke(Color.primaryYellow.opacity(0.5), lineWidth: 1)
    }
}

private enum Design {
    static let rowSpacing: CGFloat = 12
    static let cornerRadius: CGFloat = 20
}
