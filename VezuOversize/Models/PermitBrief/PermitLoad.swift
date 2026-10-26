import Foundation

nonisolated struct PermitLoad: Hashable, Codable {
    let description: String
    let height: String
    let width: String
    let length: String
    let grossWeight: String?
    let axles: Int?
}
