import Foundation

@Observable
final class PermitsViewModel {
    var permits: [Permit] = Permit.samples
    var selectedFilter: PermitFilter = .all

    var isEmpty: Bool {
        permits.isEmpty
    }

    var filteredPermits: [Permit] {
        permits.filter { matches($0, filter: selectedFilter) }
    }

    func count(for filter: PermitFilter) -> Int {
        permits.filter { matches($0, filter: filter) }.count
    }

    // TODO: Present PDF importer
    func importTapped() {}

    // TODO: Navigate to permit details
    func select(_ permit: Permit) {}

    // TODO: Open demo permit brief
    func tryDemoTapped() {}

    private func matches(_ permit: Permit, filter: PermitFilter) -> Bool {
        switch filter {
        case .all:
            true
        case .active:
            !permit.status.isExpired
        case .expired:
            permit.status.isExpired
        }
    }
}
