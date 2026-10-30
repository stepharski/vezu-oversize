import Foundation

nonisolated struct SummarizePermitRequest: Encodable, Equatable, Sendable {
    let pdfs: [PermitFile]
    // The Worker translates the brief's text into the app's language; English needs no translation.
    var language = Bundle.main.languageCode
}
