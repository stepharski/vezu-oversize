import SwiftUI

struct RouteOverviewCell: View {
    let route: PermitRoute

    var body: some View {
        VStack(alignment: .leading, spacing: Design.spacing) {
            endpoints

            Divider()
                .overlay(Color.dividerGray)

            distanceRow
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

private extension RouteOverviewCell {
    var endpoints: some View {
        VStack(alignment: .leading, spacing: .zero) {
            endpointRow(AppText.PermitBrief.start, place: route.origin, isDestination: false)
            connector
            endpointRow(AppText.PermitBrief.arrive, place: route.destination, isDestination: true)
        }
    }

    var connector: some View {
        Rectangle()
            .fill(Color.secondaryGray.opacity(0.4))
            .frame(width: Design.lineWidth, height: Design.endpointGap)
            .padding(.leading, (Design.endpointDotSize - Design.lineWidth) / 2)
    }

    var distanceRow: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(AppText.PermitBrief.totalDistance)
                .foregroundStyle(Color.secondaryGray)

            Spacer()

            if route.totalMiles > 0 {
                Text(route.totalMiles.milesText)
                    .font(.title3.bold())
                    .foregroundStyle(Color.primaryWhite)

                Text("· \(AppText.PermitBrief.steps(route.steps.count))")
                    .foregroundStyle(Color.secondaryGray)
            } else {
                Text(AppText.PermitBrief.steps(route.steps.count))
                    .foregroundStyle(Color.secondaryGray)
            }
        }
        .font(.body)
    }

    func endpointRow(_ title: String, place: String, isDestination: Bool) -> some View {
        HStack(spacing: Design.endpointSpacing) {
            Circle()
                .strokeBorder(Color.primaryYellow, lineWidth: isDestination ? 0 : 2)
                .background(Circle().fill(isDestination ? Color.primaryYellow : .clear))
                .frame(width: Design.endpointDotSize, height: Design.endpointDotSize)

            VStack(alignment: .leading, spacing: Design.textSpacing) {
                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(Color.secondaryGray)
                    .textCase(.uppercase)

                Text(place)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.primaryWhite)
            }
        }
    }
}

private extension RouteOverviewCell {
    enum Design {
        static let spacing: CGFloat = 16
        static let textSpacing: CGFloat = 2
        static let endpointSpacing: CGFloat = 12
        static let endpointDotSize: CGFloat = 14
        static let endpointGap: CGFloat = 20
        static let lineWidth: CGFloat = 2
    }
}
