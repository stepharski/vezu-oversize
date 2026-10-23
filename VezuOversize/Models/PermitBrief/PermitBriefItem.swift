import Foundation

nonisolated struct PermitBriefItem: Identifiable, Hashable, Codable {
    var id = UUID()
    let title: String
    let detail: String?
}
