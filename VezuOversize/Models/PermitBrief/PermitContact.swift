import Foundation

nonisolated struct PermitContact: Identifiable, Hashable, Codable {
    var id = UUID()
    let name: String
    let role: String
    let phone: String
}
