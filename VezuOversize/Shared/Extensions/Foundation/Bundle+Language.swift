import Foundation

extension Bundle {
    // The language the app shows its text in: "en", "es" or "uk".
    nonisolated var languageCode: String {
        preferredLocalizations.first ?? "en"
    }
}
