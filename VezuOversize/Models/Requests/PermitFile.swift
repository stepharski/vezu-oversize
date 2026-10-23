import Foundation

nonisolated struct PermitFile: Encodable, Equatable, Sendable {
    let name: String
    let base64: String
}
