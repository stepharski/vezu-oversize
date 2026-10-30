import Foundation

nonisolated struct PermitBriefTranslation: Hashable, Codable {
    let language: String
    let brief: PermitBrief
}
