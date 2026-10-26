import SwiftUI
import SwiftUIPocketKit

struct PermitsEmptyStateView: View {
    let onTryDemo: CompletionBlock

    var body: some View {
        VStack(spacing: Design.sectionSpacing) {
            Spacer()
            message
            cards
            Spacer()
        }
        .padding(.horizontal, Design.horizontalPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension PermitsEmptyStateView {
    var message: some View {
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
    }

    var titleIcon: some View {
        Image(systemName: "document.on.document")
            .font(.system(size: Design.iconSize))
            .foregroundStyle(Color.primaryYellow)
            .frame(width: Design.glowSize, height: Design.glowSize)
            .background { glow }
    }

    var glow: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [Color.yellowGlow.opacity(0.25), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: Design.glowSize / 2))
    }

    var cards: some View {
        VStack(spacing: Design.cardSpacing) {
            shareCard
            demoCard
        }
    }

    var shareCard: some View {
        cardText(
            title: AppText.PermitsEmptyState.shareTitle,
            message: AppText.PermitsEmptyState.shareMessage)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle(padding: Design.cardPadding)
    }

    var demoCard: some View {
        Button(action: onTryDemo) {
            HStack {
                cardText(
                    title: AppText.PermitsEmptyState.demoTitle,
                    message: AppText.PermitsEmptyState.demoMessage)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.primaryWhite)
            }
            .cardStyle(padding: Design.cardPadding)
            .contentShape(.rect(cornerRadius: Design.cardCornerRadius))
        }
        .buttonStyle(.plain)
    }

    func cardText(title: String, message: String) -> some View {
        VStack(alignment: .leading, spacing: Design.cardTextSpacing) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.primaryWhite)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryGray)
        }
    }
}

private enum Design {
    static let horizontalPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 28
    static let textSpacing: CGFloat = 8
    static let cardSpacing: CGFloat = 12
    static let cardTextSpacing: CGFloat = 6
    static let cardPadding: CGFloat = 18
    static let cardCornerRadius: CGFloat = 20
    static let iconSize: CGFloat = 50
    static let glowSize: CGFloat = 175
}
