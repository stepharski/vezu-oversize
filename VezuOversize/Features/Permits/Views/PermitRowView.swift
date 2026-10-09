import SwiftUI

struct PermitRowView: View {
    let permit: Permit
    private var isActive: Bool { permit.status == .active }

    var body: some View {
        HStack(alignment: .top, spacing: Design.hSpacing) {
            stateIcon

            VStack(alignment: .leading, spacing: Design.vSpacing) {
                HStack(alignment: .top) {
                    permitTitle
                    Spacer(minLength: Design.spacerSize)
                    permitNumberLabel
                }

                loadTypeLabel.padding(.top, Design.loadLabelPadding)

                HStack(alignment: .bottom) {
                    dateLabel
                    Spacer()
                    statusBadge
                }
            }
        }
        .padding(Design.padding)
        .background { cardBackground }
        .clipShape(.rect(cornerRadius: Design.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Design.cornerRadius)
                .stroke(Color.dividerGray.opacity(0.6), lineWidth: 1)
        }
    }
}

// MARK: - Components
private extension PermitRowView {
    var stateIcon: some View {
        Text("IL")
            .font(.title2.bold())
            .foregroundStyle(Color.primaryYellow)
            .frame(width: Design.iconSize, height: Design.iconSize)
            .background(
                Color.darkAmber.opacity(0.35),
                in: .rect(cornerRadius: Design.iconCornerRadius)
            )
    }

    var permitTitle: some View {
        Text(permit.title)
            .font(.headline)
            .foregroundStyle(Color.primaryWhite)
            .lineLimit(1)
    }

    var permitNumberLabel: some View {
        Text(permit.number)
            .font(.subheadline)
            .foregroundStyle(Color.secondaryGray)
            .lineLimit(1)
    }

    var loadTypeLabel: some View {
        Text("Steel pipe")
            .font(.subheadline)
            .foregroundStyle(Color.secondaryGray)
            .lineLimit(1)
    }

    var dateLabel: some View {
        Text("Oct 07 - Oct 10")
            .font(.subheadline)
            .foregroundStyle(Color.secondaryGray)
            .lineLimit(1)
    }

    var statusBadge: some View {
        let tint = isActive ? Color.statusGreen : Color.secondaryGray

        return HStack(spacing: Design.badgeSpacing) {
            Circle()
                .fill(tint)
                .frame(width: Design.badgeDotSize, height: Design.badgeDotSize)

            Text(permit.status.title.uppercased())
                .font(.caption.weight(.medium))
                .foregroundStyle(isActive
                                 ? Color.statusGreen
                                 : Color.primaryWhite.opacity(0.85))
        }
        .padding(.horizontal, Design.badgeHorizontalPadding)
        .padding(.vertical, Design.badgeVerticalPadding)
        .background(tint.opacity(isActive ? 0.12 : 0.15), in: .capsule)
    }

    var cardBackground: some View {
        ZStack(alignment: .leading) {
            Color.cardBlack.opacity(0.9)

            if isActive {
                LinearGradient(
                    colors: [Color.darkAmber.opacity(0.2), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
        }
    }
}

// MARK: - Design
private enum Design {
    static let padding: CGFloat = 12
    static let hSpacing: CGFloat = 16
    static let vSpacing: CGFloat = 6
    static let spacerSize: CGFloat = 8
    static let cornerRadius: CGFloat = 20
    static let loadLabelPadding: CGFloat = 4

    static let iconSize: CGFloat = 56
    static let iconCornerRadius: CGFloat = 14
    static let badgeSpacing: CGFloat = 6
    static let badgeDotSize: CGFloat = 8
    static let badgeHorizontalPadding: CGFloat = 10
    static let badgeVerticalPadding: CGFloat = 6
}
