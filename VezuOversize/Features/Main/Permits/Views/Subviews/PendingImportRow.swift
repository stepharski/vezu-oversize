import SwiftUI
import SwiftUIPocketKit

struct PendingImportRow: View {
    let pendingImport: PendingImport
    let onRetry: CompletionBlock
    let onRemove: CompletionBlock

    var body: some View {
        HStack(alignment: .top, spacing: Design.hSpacing) {
            statusIcon

            VStack(alignment: .leading, spacing: Design.vSpacing) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.primaryWhite)
                    .lineLimit(1)

                Text(fileText)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryGray)
                    .lineLimit(1)

                if let errorMessage = pendingImport.errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryGray)

                    actions
                        .padding(.top, Design.actionsTopPadding)
                } else {
                    Text(AppText.PermitImport.readingHint)
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryGray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Design.padding)
        .background(Color.cardBlack.opacity(0.9), in: .rect(cornerRadius: Design.cornerRadius))
        .overlay { cardBorder }
    }
}

private extension PendingImportRow {
    var title: String {
        if pendingImport.isReading {
            return AppText.PermitImport.reading
        }
        return pendingImport.canRetry ? AppText.PermitImport.failed : AppText.PermitImport.notAPermit
    }

    var fileText: String {
        let extraFiles = pendingImport.fileCount - 1
        guard extraFiles > 0 else { return pendingImport.fileName }
        return "\(pendingImport.fileName) \(AppText.PermitImport.moreFiles(extraFiles))"
    }

    var statusIcon: some View {
        Group {
            if pendingImport.isReading {
                ProgressView()
                    .tint(Color.primaryYellow)
            } else {
                Image(systemName: "exclamationmark.triangle")
                    .font(.title2)
                    .foregroundStyle(Color.primaryYellow)
            }
        }
        .frame(width: Design.iconSize, height: Design.iconSize)
        .background(Color.darkAmber.opacity(0.35), in: .rect(cornerRadius: Design.iconCornerRadius))
    }

    var actions: some View {
        HStack(spacing: Design.actionSpacing) {
            if pendingImport.canRetry {
                Button(AppText.PermitImport.retry, action: onRetry)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.primaryYellow)
            }

            Button(AppText.PermitImport.remove, action: onRemove)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.secondaryGray)
        }
        .buttonStyle(.borderless)
    }

    var cardBorder: some View {
        RoundedRectangle(cornerRadius: Design.cornerRadius)
            .stroke(
                pendingImport.isReading ? Color.dividerGray.opacity(0.6) : Color.primaryYellow.opacity(0.5),
                lineWidth: 1)
    }
}

private enum Design {
    static let padding: CGFloat = 12
    static let hSpacing: CGFloat = 16
    static let vSpacing: CGFloat = 6
    static let actionsTopPadding: CGFloat = 4
    static let actionSpacing: CGFloat = 20
    static let cornerRadius: CGFloat = 20
    static let iconSize: CGFloat = 56
    static let iconCornerRadius: CGFloat = 14
}
