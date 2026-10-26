import SwiftUI

struct RequiredEquipmentCell: View {
    let equipment: [PermitBriefItem]

    var body: some View {
        BriefSectionCell(title: AppText.PermitBrief.requiredEquipment) {
            VStack(alignment: .leading, spacing: Design.rowSpacing) {
                ForEach(equipment) { item in
                    row(for: item)
                }
            }
        }
    }
}

private extension RequiredEquipmentCell {
    func row(for item: PermitBriefItem) -> some View {
        BriefIconRow(
            systemImage: "checkmark",
            title: item.title,
            detail: item.detail)
    }
}

private enum Design {
    static let rowSpacing: CGFloat = 14
}
