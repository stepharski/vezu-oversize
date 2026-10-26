import Foundation

enum PermitFilter: CaseIterable {
    case all
    case active
    case expired

    var title: String {
        switch self {
        case .all:
            return AppText.Filter.all
        case .active:
            return AppText.Filter.active
        case .expired:
            return AppText.Filter.expired
        }
    }
}
