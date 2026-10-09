import Foundation

enum PermitFilter: CaseIterable {
    case all
    case active
    case expired

    var title: String {
        switch self {
        case .all:
            AppText.Filter.all
        case .active:
            AppText.Filter.active
        case .expired:
            AppText.Filter.expired
        }
    }
}
