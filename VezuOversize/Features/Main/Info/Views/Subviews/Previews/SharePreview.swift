import SwiftUI

struct SharePreview: View {
    var body: some View {
        InfoPreviewFrame {
            VStack(spacing: Design.spacing) {
                fileRow

                Rectangle()
                    .fill(Color.dividerGray)
                    .frame(height: 1)

                apps
            }
            .padding(Design.sheetPadding)
            .background(Color.sheetGray, in: .rect(cornerRadius: Design.sheetCornerRadius))
        }
    }
}

private extension SharePreview {
    var fileRow: some View {
        HStack(spacing: Design.fileSpacing) {
            Image(systemName: "doc.fill")
                .font(.title3)
                .foregroundStyle(Color.primaryWhite)
                .frame(width: Design.fileIconSize, height: Design.fileIconSize)
                .background(Color.dividerGray, in: .rect(cornerRadius: Design.fileIconCornerRadius))

            VStack(alignment: .leading, spacing: Design.lineSpacing) {
                Text(AppText.PermitImport.permitFileName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.primaryWhite)

                placeholderLine(width: Design.shortLineWidth)
            }

            Spacer()

            Image(systemName: "xmark.circle.fill")
                .font(.title3)
                .foregroundStyle(Color.secondaryGray.opacity(0.5))
        }
    }

    var apps: some View {
        HStack(alignment: .top, spacing: Design.appSpacing) {
            otherApp("dot.radiowaves.left.and.right")
            otherApp("message.fill")
            otherApp("envelope.fill")
            vezuApp
        }
    }

    func otherApp(_ systemImage: String) -> some View {
        VStack(spacing: Design.appLabelSpacing) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(Color.secondaryGray)
                .frame(width: Design.appIconSize, height: Design.appIconSize)
                .background(Color.dividerGray, in: .rect(cornerRadius: Design.appIconCornerRadius))

            placeholderLine(width: Design.appLabelWidth)
        }
    }

    var vezuApp: some View {
        VStack(spacing: Design.appLabelSpacing) {
            Text(verbatim: "V")
                .font(.title.weight(.black))
                .foregroundStyle(Color.nearBlack)
                .frame(width: Design.appIconSize, height: Design.appIconSize)
                .background(Color.primaryYellow, in: .rect(cornerRadius: Design.appIconCornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: Design.highlightCornerRadius)
                        .stroke(Color.primaryYellow, lineWidth: 2)
                        .padding(-Design.highlightInset)
                }
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "hand.tap.fill")
                        .font(.title2)
                        .foregroundStyle(Color.primaryWhite)
                        .shadow(radius: 4)
                        .offset(x: Design.handOffset, y: Design.handOffset)
                }

            Text(verbatim: "VEZU")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Color.primaryWhite)
        }
    }

    func placeholderLine(width: CGFloat) -> some View {
        Capsule()
            .fill(Color.dividerGray)
            .frame(width: width, height: Design.lineHeight)
    }
}

private enum Design {
    static let spacing: CGFloat = 14
    static let sheetPadding: CGFloat = 14
    static let sheetCornerRadius: CGFloat = 18
    static let fileSpacing: CGFloat = 12
    static let fileIconSize: CGFloat = 40
    static let fileIconCornerRadius: CGFloat = 8
    static let lineSpacing: CGFloat = 6
    static let lineHeight: CGFloat = 6
    static let shortLineWidth: CGFloat = 70
    static let appSpacing: CGFloat = 18
    static let appIconSize: CGFloat = 48
    static let appIconCornerRadius: CGFloat = 12
    static let appLabelSpacing: CGFloat = 8
    static let appLabelWidth: CGFloat = 32
    static let highlightCornerRadius: CGFloat = 15
    static let highlightInset: CGFloat = 4
    static let handOffset: CGFloat = 12
}
