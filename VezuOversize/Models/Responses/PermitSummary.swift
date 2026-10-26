import Foundation

nonisolated struct PermitSummary: Decodable, Sendable {
    let state: String
    let stateCode: String
    let permitType: String
    let number: String
    let fee: Double
    let validFrom: String
    let validTo: String
    let load: PermitSummaryLoad
    let vehicle: PermitSummaryVehicle
    let route: PermitSummaryRoute
    let critical: PermitSummaryCritical?
    let restrictions: [PermitSummaryRestriction]
    let escorts: [PermitSummaryEscort]
    let alerts: [PermitSummaryItem]
    let equipment: [PermitSummaryItem]
    let documents: [PermitSummaryItem]
    let contacts: [PermitSummaryContact]
}
