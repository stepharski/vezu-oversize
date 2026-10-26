import Foundation

nonisolated struct SummarizePermitRequest: Encodable, Equatable, Sendable {
    let pdfs: [PermitFile]
}
