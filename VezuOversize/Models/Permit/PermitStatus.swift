import Foundation

enum PermitStatus: Hashable {
    case active
    case upcoming
    case expired

    var title: String {
        switch self {
        case .active:
            return AppText.PermitStatus.active
        case .upcoming:
            return AppText.PermitStatus.upcoming
        case .expired:
            return AppText.PermitStatus.expired
        }
    }

    var sortRank: Int {
        switch self {
        case .active:
            return 0
        case .upcoming:
            return 1
        case .expired:
            return 2
        }
    }
}
