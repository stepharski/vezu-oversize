import Foundation

nonisolated struct PermitRestriction: Identifiable, Hashable, Codable {
    enum Kind: String, Hashable, Codable {
        case speed
        case travelHours
        case nightTravel
        case weekend
        case holiday
        case weather
        case other

        var systemImage: String {
            switch self {
            case .speed:
                return "gauge.with.needle"
            case .travelHours:
                return "clock"
            case .nightTravel:
                return "moon.stars"
            case .weekend:
                return "calendar"
            case .holiday:
                return "calendar.badge.exclamationmark"
            case .weather:
                return "cloud.rain"
            case .other:
                return "info.circle"
            }
        }

        init(from decoder: Decoder) throws {
            self = Kind(rawValue: try decoder.enumRawValue()) ?? .other
        }
    }

    var id = UUID()
    let kind: Kind
    let title: String
    let detail: String?
}
