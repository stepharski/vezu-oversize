import Foundation

enum PermitStatus: Hashable {
    case active
    case expired

    var title: String {
        switch self {
        case .active:
            AppText.PermitStatus.active
        case .expired:
            AppText.PermitStatus.expired
        }
    }

    var isExpired: Bool {
        self == .expired
    }
}
