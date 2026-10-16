import SwiftUI

struct PermitStatusBadge: View {
    let status: PermitStatus

    var body: some View {
        HStack(spacing: Design.spacing) {
            dot
            title
        }
        .padding(.horizontal, Design.horizontalPadding)
        .padding(.vertical, Design.verticalPadding)
        .background(tint.opacity(isActive ? 0.12 : 0.15), in: .capsule)
    }
}

// MARK: - Components
private extension PermitStatusBadge {
    var isActive: Bool {
        status == .active
    }

    var tint: Color {
        isActive ? .statusGreen : .secondaryGray
    }

    var dot: some View {
        Circle()
            .fill(tint)
            .frame(width: Design.dotSize, height: Design.dotSize)
    }

    var title: some View {
        Text(status.title.uppercased())
            .font(.caption.weight(.medium))
            .foregroundStyle(isActive ? Color.statusGreen : Color.primaryWhite.opacity(0.85))
    }
}

// MARK: - Design
private enum Design {
    static let spacing: CGFloat = 6
    static let dotSize: CGFloat = 8
    static let horizontalPadding: CGFloat = 10
    static let verticalPadding: CGFloat = 6
}

#Preview {
    HStack {
        PermitStatusBadge(status: .active)
        PermitStatusBadge(status: .expired)
    }
    .padding()
    .background(Color.nearBlack)
}
