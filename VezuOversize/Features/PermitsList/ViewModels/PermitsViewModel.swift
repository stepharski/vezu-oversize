import Foundation

@Observable
final class PermitsViewModel {
    var permits: [Permit] = Permit.samples
    var selectedFilter: PermitFilter = .all
    var selectedBrief: PermitBrief?

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

    // TODO: Open the selected permit's own brief
    func select(_ permit: Permit) {
        selectedBrief = .demo
    }

    func tryDemoTapped() {
        selectedBrief = .demo
    }

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
