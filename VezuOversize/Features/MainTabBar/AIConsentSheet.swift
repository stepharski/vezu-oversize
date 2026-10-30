import SwiftUI

struct AIConsentSheet: View {
    let onAgree: () -> Void
    let onDecline: () -> Void

    var body: some View {
        ZStack {
            Color.sheetGray
                .ignoresSafeArea()
            content
        }
        .presentationDetents([.large])
        .presentationBackground(Color.sheetGray)
    }
}

private extension AIConsentSheet {
    var content: some View {
        VStack(spacing: Design.spacing) {
            ScrollView {
                VStack(alignment: .leading, spacing: Design.spacing) {
                    header
                    points
                    Link(AppText.AIConsent.privacyPolicy, destination: LinkConstants.privacyPolicy)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.primaryYellow)
                }
                .padding(.top, Design.topPadding)
            }
            .scrollIndicators(.hidden)

            buttons
        }
        .padding(.horizontal, Design.horizontalPadding)
        .padding(.bottom, Design.bottomPadding)
    }

    var header: some View {
        VStack(alignment: .leading, spacing: Design.textSpacing) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(Color.primaryYellow)
                .frame(width: Design.iconSize, height: Design.iconSize)
                .background(Color.darkAmber.opacity(0.35), in: .rect(cornerRadius: Design.iconCornerRadius))
                .padding(.bottom, Design.textSpacing)

            Text(AppText.AIConsent.title)
                .font(.title2.bold())
                .foregroundStyle(Color.primaryWhite)

            Text(AppText.AIConsent.subtitle)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryGray)
        }
    }

    var points: some View {
        VStack(alignment: .leading, spacing: Design.rowSpacing) {
            BriefIconRow(
                systemImage: "doc.text",
                title: AppText.AIConsent.sentTitle,
                detail: AppText.AIConsent.sentMessage)
            BriefIconRow(
                systemImage: "cpu",
                title: AppText.AIConsent.readerTitle,
                detail: AppText.AIConsent.readerMessage)
            BriefIconRow(
                systemImage: "clock.arrow.circlepath",
                title: AppText.AIConsent.keptTitle,
                detail: AppText.AIConsent.keptMessage)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    var buttons: some View {
        VStack(spacing: Design.buttonSpacing) {
            Button(action: onAgree) {
                Text(AppText.AIConsent.agree)
                    .font(.headline)
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, minHeight: Design.buttonHeight)
                    .background(Color.primaryYellow, in: .capsule)
            }

            Button(AppText.AIConsent.notNow, action: onDecline)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.secondaryGray)
                .frame(minHeight: Design.buttonHeight)
        }
    }
}

private extension AIConsentSheet {
    enum Design {
        static let spacing: CGFloat = 20
        static let topPadding: CGFloat = 32
        static let horizontalPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 8
        static let iconSize: CGFloat = 52
        static let iconCornerRadius: CGFloat = 14
        static let textSpacing: CGFloat = 6
        static let rowSpacing: CGFloat = 14
        static let buttonSpacing: CGFloat = 4
        static let buttonHeight: CGFloat = 50
    }
}
