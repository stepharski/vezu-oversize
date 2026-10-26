import Foundation

nonisolated struct PermitSummaryVehicle: Decodable, Sendable {
    let year: String
    let make: String
    let type: String
    let unitNumber: String
    let plate: String
    let plateState: String
    let vin: String
}
