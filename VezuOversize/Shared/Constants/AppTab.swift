import Foundation

enum AppTab {
    case permits
    case info

    var title: String {
        switch self {
        case .permits:
            return AppText.AppTab.permits
        case .info:
            return AppText.AppTab.info
        }
    }

    var imageName: String {
        switch self {
        case .permits:
            return "doc.text.fill"
        case .info:
            return "info.circle"
        }
    }
}
