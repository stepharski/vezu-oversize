import SwiftUI

struct KeyRestrictionsCell: View {
    let restrictions: [PermitRestriction]
    let escorts: [PermitEscortRule]
    let critical: PermitCriticalInfo?

    var body: some View {
        BriefSectionCell(title: AppText.PermitBrief.keyRestrictions) {
            VStack(alignment: .leading, spacing: Design.rowSpacing) {
                if let critical {
                    criticalRows(critical)

                    if !otherRestrictions.isEmpty {
                        Divider()
                            .overlay(Color.dividerGray)
                    }
                } else if restrictions.isEmpty && escorts.isEmpty {
                    emptyLabel
                }

                ForEach(otherRestrictions) { restriction in
                    row(for: restriction)
                }

                if critical == nil {
                    ForEach(escorts) { escort in
                        BriefIconRow(
                            systemImage: "car",
                            title: summary(for: escort),
                            detail: escort.condition,
                            detailColor: .primaryYellow)
                    }
                }
            }
        }
    }
}

private extension KeyRestrictionsCell {
    var otherRestrictions: [PermitRestriction] {
        guard critical != nil else { return restrictions }
        return restrictions.filter { $0.kind != .nightTravel && $0.kind != .speed }
    }

    var emptyLabel: some View {
        Text(AppText.PermitBrief.noRestrictions)
            .foregroundStyle(Color.secondaryGray)
    }

    @ViewBuilder
    func criticalRows(_ critical: PermitCriticalInfo) -> some View {
        criticalRow(for: critical.nightTravel, label: AppText.PermitBrief.nightTravel, systemImage: "moon.stars")
        criticalRow(for: critical.maxSpeed, label: AppText.PermitBrief.maxSpeed, systemImage: "gauge.with.needle")

        VStack(alignment: .leading, spacing: Design.escortRuleSpacing) {
            criticalRow(
                for: critical.escorts,
                label: AppText.PermitBrief.escorts,
                systemImage: "car.2",
                note: escorts.count == 1 ? escorts.first.map(ruleText) : nil,
                showsSummary: escorts.isEmpty)

            if escorts.count > 1 {
                ForEach(escorts) { escort in
                    escortRuleLine(escort)
                }
            }
        }
    }

    func criticalRow(for answer: PermitCriticalAnswer,
                     label: String,
                     systemImage: String,
                     note: String? = nil,
                     showsSummary: Bool = true) -> some View {
        BriefIconRow(
            systemImage: systemImage,
            title: label,
            detail: statusTitle(for: answer),
            detailColor: answer.isStated ? .primaryYellow : .secondaryGray,
            note: note ?? (answer.isStated && showsSummary ? answer.summary : nil))
    }

    func ruleText(for escort: PermitEscortRule) -> String {
        escort.condition.map { "\(summary(for: escort)) — \($0)" } ?? summary(for: escort)
    }

    func escortRuleLine(_ escort: PermitEscortRule) -> some View {
        Label {
            Text(ruleText(for: escort))
                .font(.subheadline)
                .foregroundStyle(Color.secondaryGray)
        } icon: {
            Image(systemName: "circle.fill")
                .imageScale(.small)
                .foregroundStyle(Color.primaryYellow)
        }
        .padding(.leading, Design.escortRuleIndent)
    }

    func statusTitle(for answer: PermitCriticalAnswer) -> String {
        if answer.status == .stated, let mph = answer.mph {
            return AppText.PermitBrief.speed(mph)
        }
        return AppText.PermitBrief.title(for: answer.status)
    }

    func summary(for escort: PermitEscortRule) -> String {
        let cars = AppText.PermitBrief.escortCars(escort.count)

        switch escort.position {
        case .front:
            return "\(cars) · \(AppText.PermitBrief.front)"
        case .rear:
            return "\(cars) · \(AppText.PermitBrief.rear)"
        case .frontAndRear:
            return "\(cars) · \(AppText.PermitBrief.frontAndRear)"
        case .unspecified:
            return cars
        }
    }

    func row(for restriction: PermitRestriction) -> some View {
        BriefIconRow(
            systemImage: restriction.kind.systemImage,
            title: restriction.title,
            detail: restriction.detail)
    }
}

private extension KeyRestrictionsCell {
    enum Design {
        static let rowSpacing: CGFloat = 14
        static let escortRuleSpacing: CGFloat = 8
        static let escortRuleIndent: CGFloat = 48
    }
}
