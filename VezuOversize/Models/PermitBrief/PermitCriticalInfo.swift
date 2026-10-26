import Foundation

nonisolated struct PermitCriticalInfo: Hashable, Codable {
    let nightTravel: PermitCriticalAnswer
    let maxSpeed: PermitCriticalAnswer
    let escorts: PermitCriticalAnswer
}
