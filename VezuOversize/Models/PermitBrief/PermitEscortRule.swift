import Foundation

nonisolated struct PermitEscortRule: Identifiable, Hashable, Codable {
    enum Position: String, Hashable, Codable {
        case front
        case rear
        case frontAndRear
        case unspecified

        init(from decoder: Decoder) throws {
            self = Position(rawValue: try decoder.enumRawValue()) ?? .unspecified
        }
    }

    var id = UUID()
    let count: Int
    let position: Position
    let condition: String?
}
