import SwiftUI
import SwiftUIPocketKit

struct PermitsEmptyStateView: View {
    let onTryDemo: CompletionBlock

    var body: some View {
        VStack(spacing: Design.sectionSpacing) {
            Spacer()
            VStack(spacing: Design.textSpacing) {
                titleIcon
                Text(AppText.PermitsEmptyState.title)
                    .font(.title.bold())
                    .foregroundStyle(Color.primaryWhite)

                Text(AppText.PermitsEmptyState.subtitle)
                    .font(.body)
                    .foregroundStyle(Color.secondaryGray)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: Design.cardSpacing) {
                shareCard
                demoCard
            }
            Spacer()
        }
        .padding(.horizontal, Design.xPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Components
private extension PermitsEmptyStateView {
    var titleIcon: some View {
        Image(systemName: "document.on.document")
            .font(.system(size: Design.iconSize))
            .foregroundStyle(Color.primaryYellow)
            .frame(width: Design.glowSize, height: Design.glowSize)
            .background {
                Circle()
                    .fill(RadialGradient(
                        colors: [Color.yellowGlow.opacity(0.25), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: Design.glowSize / 2)
                    )
            }
    }

    var shareCard: some View {
        VStack(alignment: .leading, spacing: Design.cardTextSpacing) {
            Text(AppText.PermitsEmptyState.shareTitle)
                .font(.headline)
                .foregroundStyle(Color.primaryWhite)

            Text(AppText.PermitsEmptyState.shareMessage)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryGray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .modifier(StrokedCardModifier())
    }

    var demoCard: some View {
        Button(action: onTryDemo) {
            HStack {
                VStack(alignment: .leading, spacing: Design.cardTextSpacing) {
                    Text(AppText.PermitsEmptyState.demoTitle)
                        .font(.headline)
                        .foregroundStyle(Color.primaryWhite)

                    Text(AppText.PermitsEmptyState.demoMessage)
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryGray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.primaryWhite)
            }
            .modifier(StrokedCardModifier())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Modifiers
private struct StrokedCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Design.cardPadding)
            .background(
                Color.cardBlack.opacity(0.9),
                in: .rect(cornerRadius: Design.cardCornerRadius)
            )
            .overlay {
                RoundedRectangle(cornerRadius: Design.cardCornerRadius)
                    .stroke(Color.dividerGray.opacity(0.6), lineWidth: 1)
            }
            .contentShape(.rect(cornerRadius: Design.cardCornerRadius))
    }
}

// MARK: - Design
private enum Design {
    static let xPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 28
    static let textSpacing: CGFloat = 8
    static let cardSpacing: CGFloat = 12
    static let cardTextSpacing: CGFloat = 6
    static let cardPadding: CGFloat = 18
    static let cardCornerRadius: CGFloat = 20
    static let iconSize: CGFloat = 50
    static let glowSize: CGFloat = 175
}

#Preview {
    PermitsEmptyStateView(onTryDemo: {})
        .background(Color.nearBlack)
}
