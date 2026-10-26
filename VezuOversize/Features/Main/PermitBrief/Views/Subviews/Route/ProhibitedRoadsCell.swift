import SwiftUI

struct ProhibitedRoadsCell: View {
    let roads: [String]

    var body: some View {
        BriefSectionCell(title: AppText.PermitBrief.notAllowed) {
            VStack(alignment: .leading, spacing: Design.rowSpacing) {
                ForEach(roads, id: \.self) { road in
                    row(for: road)
                }
            }
        }
    }
}

private extension ProhibitedRoadsCell {
    func row(for road: String) -> some View {
        BriefIconRow(systemImage: "nosign", title: road)
    }
}

private enum Design {
    static let rowSpacing: CGFloat = 14
}
