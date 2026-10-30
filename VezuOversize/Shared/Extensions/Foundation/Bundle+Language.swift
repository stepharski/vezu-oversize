import Foundation

extension Bundle {
    nonisolated var languageCode: String {
        preferredLocalizations.first ?? "en"
    }
}
