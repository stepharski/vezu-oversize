import Foundation

enum PermitStatus: Hashable {
    case active
    case expired

    var title: String {
        switch self {
        case .active:
            AppText.Filter.active
        case .expired:
            AppText.Filter.expired
        }
    }

    var isExpired: Bool {
        self != .active
    }
}
