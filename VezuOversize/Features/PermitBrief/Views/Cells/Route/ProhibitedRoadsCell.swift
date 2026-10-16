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

// MARK: - Components
private extension ProhibitedRoadsCell {
    func row(for road: String) -> some View {
        BriefIconRow(systemImage: "nosign", title: road)
    }
}

// MARK: - Design
private enum Design {
    static let rowSpacing: CGFloat = 14
}

#Preview {
    ProhibitedRoadsCell(roads: PermitBrief.demo.route.prohibitedRoads)
        .padding()
        .background(Color.nearBlack)
}
