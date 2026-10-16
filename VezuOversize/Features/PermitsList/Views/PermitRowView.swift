import SwiftUI

struct PermitRowView: View {
    let permit: Permit

    var body: some View {
        HStack(alignment: .top, spacing: Design.hSpacing) {
            stateIcon

            VStack(alignment: .leading, spacing: Design.vSpacing) {
                header

                loadLabel
                    .padding(.top, Design.loadTopPadding)

                footer
            }
        }
        .padding(Design.padding)
        .background { cardBackground }
        .clipShape(.rect(cornerRadius: Design.cornerRadius))
        .overlay { cardBorder }
    }
}

// MARK: - Components
private extension PermitRowView {
    var isActive: Bool {
        permit.status == .active
    }

    var stateIcon: some View {
        Text(permit.stateCode)
            .font(.title2.bold())
            .foregroundStyle(Color.primaryYellow)
            .frame(width: Design.iconSize, height: Design.iconSize)
            .background(
                Color.darkAmber.opacity(0.35),
                in: .rect(cornerRadius: Design.iconCornerRadius)
            )
    }

    var header: some View {
        HStack(alignment: .top) {
            Text(permit.title)
                .font(.headline)
                .foregroundStyle(Color.primaryWhite)
                .lineLimit(1)

            Spacer(minLength: Design.spacerSize)

            Text(permit.number)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryGray)
                .lineLimit(1)
        }
    }

    var loadLabel: some View {
        Text(permit.loadDescription)
            .font(.subheadline)
            .foregroundStyle(Color.secondaryGray)
            .lineLimit(1)
    }

    var footer: some View {
        HStack(alignment: .bottom) {
            Text(permit.validFrom.rangeText(to: permit.validTo))
                .font(.subheadline)
                .foregroundStyle(Color.secondaryGray)
                .lineLimit(1)

            Spacer()

            PermitStatusBadge(status: permit.status)
        }
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

    var cardBorder: some View {
        RoundedRectangle(cornerRadius: Design.cornerRadius)
            .stroke(Color.dividerGray.opacity(0.6), lineWidth: 1)
    }
}

// MARK: - Design
private enum Design {
    static let padding: CGFloat = 12
    static let hSpacing: CGFloat = 16
    static let vSpacing: CGFloat = 6
    static let spacerSize: CGFloat = 8
    static let loadTopPadding: CGFloat = 4
    static let cornerRadius: CGFloat = 20
    static let iconSize: CGFloat = 56
    static let iconCornerRadius: CGFloat = 14
}

#Preview {
    VStack(spacing: 12) {
        ForEach(Permit.samples) { permit in
            PermitRowView(permit: permit)
        }
    }
    .padding()
    .background(Color.nearBlack)
}
