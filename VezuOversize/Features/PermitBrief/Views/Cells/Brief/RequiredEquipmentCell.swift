import SwiftUI

struct RequiredEquipmentCell: View {
    let equipment: [PermitBrief.Item]

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

// MARK: - Components
private extension RequiredEquipmentCell {
    func row(for item: PermitBrief.Item) -> some View {
        BriefIconRow(
            systemImage: "checkmark",
            title: item.title,
            detail: item.detail
        )
    }
}

// MARK: - Design
private enum Design {
    static let rowSpacing: CGFloat = 14
}

#Preview {
    RequiredEquipmentCell(equipment: PermitBrief.demo.equipment)
        .padding()
        .background(Color.nearBlack)
}
