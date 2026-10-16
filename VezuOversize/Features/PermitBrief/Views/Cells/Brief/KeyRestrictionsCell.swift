import SwiftUI

struct KeyRestrictionsCell: View {
    let restrictions: [PermitBrief.Restriction]

    var body: some View {
        BriefSectionCell(title: AppText.PermitBrief.keyRestrictions) {
            if restrictions.isEmpty {
                emptyLabel
            } else {
                restrictionsList
            }
        }
    }
}

// MARK: - Components
private extension KeyRestrictionsCell {
    var emptyLabel: some View {
        Text(AppText.PermitBrief.noRestrictions)
            .foregroundStyle(Color.secondaryGray)
    }

    var restrictionsList: some View {
        VStack(alignment: .leading, spacing: Design.rowSpacing) {
            ForEach(restrictions) { restriction in
                row(for: restriction)
            }
        }
    }

    func row(for restriction: PermitBrief.Restriction) -> some View {
        BriefIconRow(
            systemImage: restriction.kind.systemImage,
            title: restriction.title,
            detail: restriction.detail
        )
    }
}

// MARK: - Design
private enum Design {
    static let rowSpacing: CGFloat = 14
}

#Preview {
    KeyRestrictionsCell(restrictions: PermitBrief.demo.restrictions)
        .padding()
        .background(Color.nearBlack)
}
