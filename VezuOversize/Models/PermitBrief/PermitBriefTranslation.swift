import Foundation

// The brief in the language the app used when the permit was read. Other languages show English.
nonisolated struct PermitBriefTranslation: Hashable, Codable {
    let language: String
    let brief: PermitBrief
}
