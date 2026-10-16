import SwiftUI

struct AlertsCell: View {
    let alerts: [PermitBrief.Item]

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

// MARK: - Components
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

// MARK: - Design
private enum Design {
    static let rowSpacing: CGFloat = 12
    static let cornerRadius: CGFloat = 20
}

#Preview {
    AlertsCell(alerts: PermitBrief.demo.alerts)
        .padding()
        .background(Color.nearBlack)
}
