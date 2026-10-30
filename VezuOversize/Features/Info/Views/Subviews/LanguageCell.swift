import SwiftUI
import SwiftUIPocketKit

struct LanguageCell: View {
    let languageName: String
    let onTap: CompletionBlock

    var body: some View {
        InfoActionRow(
            systemImage: "globe",
            title: AppText.Info.language,
            value: languageName,
            action: onTap)
        .cardStyle(padding: Design.padding)
    }
}

private extension LanguageCell {
    enum Design {
        static let padding: CGFloat = 16
    }
}
