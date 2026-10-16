import SwiftUI

struct RouteDirectionsCell: View {
    let route: PermitBrief.RouteInfo

    var body: some View {
        BriefSectionCell(title: AppText.PermitBrief.directions) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(route.steps.enumerated()), id: \.element.id) { index, step in
                    stepRow(step, number: index + 1, cumulativeMiles: cumulativeMiles(through: index))
                }

                arrivalRow
            }
        }
    }
}

// MARK: - Components
private extension RouteDirectionsCell {
    func stepRow(_ step: PermitBrief.RouteStep, number: Int, cumulativeMiles: Double) -> some View {
        HStack(alignment: .top, spacing: Design.stepSpacing) {
            timelineMarker(number: number)

            stepDetails(step)
                .padding(.bottom, Design.stepBottomPadding)

            Spacer(minLength: Design.spacerSize)

            stepDistance(step.miles, cumulativeMiles: cumulativeMiles)
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    func timelineMarker(number: Int) -> some View {
        VStack(spacing: 0) {
            Text("\(number)")
                .font(.footnote.weight(.bold))
                .foregroundStyle(Color.primaryYellow)
                .frame(width: Design.badgeSize, height: Design.badgeSize)
                .background(Color.darkAmber.opacity(0.35), in: .circle)

            Rectangle()
                .fill(Color.secondaryGray.opacity(0.3))
                .frame(width: Design.lineWidth)
                .frame(maxHeight: .infinity)
        }
    }

    func stepDetails(_ step: PermitBrief.RouteStep) -> some View {
        VStack(alignment: .leading, spacing: Design.textSpacing) {
            HStack(spacing: Design.tollSpacing) {
                Text(step.road)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.primaryWhite)

                if step.isToll {
                    tollBadge
                }
            }

            Text(step.instruction)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryGray)
        }
    }

    func stepDistance(_ miles: Double, cumulativeMiles: Double) -> some View {
        VStack(alignment: .trailing, spacing: Design.textSpacing) {
            Text(miles.milesText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.primaryWhite)

            Text(cumulativeMiles.milesText)
                .font(.caption)
                .foregroundStyle(Color.secondaryGray)
        }
    }

    var tollBadge: some View {
        Text(AppText.PermitBrief.toll.uppercased())
            .font(.caption2.weight(.bold))
            .foregroundStyle(Color.primaryYellow)
            .padding(.horizontal, Design.tollXPadding)
            .padding(.vertical, Design.tollYPadding)
            .background(Color.darkAmber.opacity(0.35), in: .capsule)
    }

    var arrivalRow: some View {
        HStack(alignment: .top, spacing: Design.stepSpacing) {
            Image(systemName: "flag.checkered")
                .font(.footnote.weight(.bold))
                .foregroundStyle(Color.nearBlack)
                .frame(width: Design.badgeSize, height: Design.badgeSize)
                .background(Color.primaryYellow, in: .circle)

            VStack(alignment: .leading, spacing: Design.textSpacing) {
                Text(AppText.PermitBrief.arrive)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.primaryWhite)

                Text(route.destination)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryGray)
            }

            Spacer(minLength: Design.spacerSize)

            Text(route.totalMiles.milesText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.primaryYellow)
        }
    }

    func cumulativeMiles(through index: Int) -> Double {
        route.steps.prefix(index + 1).reduce(0) { $0 + $1.miles }
    }
}

// MARK: - Design
private enum Design {
    static let textSpacing: CGFloat = 2
    static let spacerSize: CGFloat = 8
    static let lineWidth: CGFloat = 2
    static let stepSpacing: CGFloat = 12
    static let badgeSize: CGFloat = 28
    static let stepBottomPadding: CGFloat = 18
    static let tollSpacing: CGFloat = 6
    static let tollXPadding: CGFloat = 6
    static let tollYPadding: CGFloat = 2
}

#Preview {
    ScrollView {
        RouteDirectionsCell(route: PermitBrief.demo.route)
            .padding()
    }
    .background(Color.nearBlack)
}
