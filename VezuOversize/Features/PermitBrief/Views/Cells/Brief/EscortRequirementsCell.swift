import SwiftUI

struct EscortRequirementsCell: View {
    let escorts: [PermitBrief.EscortRule]

    var body: some View {
        BriefSectionCell(title: AppText.PermitBrief.escortRequirements) {
            if escorts.isEmpty {
                noEscortRow
            } else {
                escortsList
            }
        }
    }
}

// MARK: - Components
private extension EscortRequirementsCell {
    var noEscortRow: some View {
        BriefIconRow(
            systemImage: "checkmark",
            title: AppText.PermitBrief.noEscortRequired
        )
    }

    var escortsList: some View {
        VStack(alignment: .leading, spacing: Design.rowSpacing) {
            ForEach(escorts) { escort in
                row(for: escort)
            }
        }
    }

    func row(for escort: PermitBrief.EscortRule) -> some View {
        BriefIconRow(
            systemImage: "car",
            title: summary(for: escort),
            detail: escort.condition,
            detailColor: .primaryYellow
        )
    }

    func summary(for escort: PermitBrief.EscortRule) -> String {
        let cars = AppText.PermitBrief.escortCars(escort.count)

        return switch escort.position {
        case .front: "\(cars) · \(AppText.PermitBrief.front)"
        case .rear: "\(cars) · \(AppText.PermitBrief.rear)"
        case .frontAndRear: "\(cars) · \(AppText.PermitBrief.frontAndRear)"
        case .unspecified: cars
        }
    }
}

// MARK: - Design
private enum Design {
    static let rowSpacing: CGFloat = 14
}

#Preview {
    VStack {
        EscortRequirementsCell(escorts: PermitBrief.demo.escorts)
        EscortRequirementsCell(escorts: PermitBrief.demoIllinois.escorts)
    }
    .padding()
    .background(Color.nearBlack)
}
