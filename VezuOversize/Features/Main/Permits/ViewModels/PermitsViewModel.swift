import Foundation

@Observable
final class PermitsViewModel {
    var selectedFilter: PermitFilter = .all
    var selectedBrief: PermitBrief?
    var isFilePickerPresented = false
    var isGroupingChoicePresented = false
    private(set) var pickedURLs: [URL] = []
    private(set) var highlightedPermitID: UUID?

    let importManager: ImportManager
    let permitManager: PermitManager

    init(permitManager: PermitManager, importManager: ImportManager) {
        self.permitManager = permitManager
        self.importManager = importManager
    }

    var permits: [Permit] {
        let permits = permitManager.records.compactMap { record in
            record.brief.map { Permit(id: record.id, brief: $0) }
        }
        return permits.enumerated()
            .sorted { lhs, rhs in
                let (first, second) = (lhs.element, rhs.element)
                if first.status != second.status {
                    return first.status.sortRank < second.status.sortRank
                }
                switch first.status {
                case .active where first.validTo != second.validTo:
                    return first.validTo < second.validTo
                case .upcoming where first.validFrom != second.validFrom:
                    return first.validFrom < second.validFrom
                case .expired where first.validTo != second.validTo:
                    return first.validTo > second.validTo
                default:
                    return lhs.offset < rhs.offset
                }
            }
            .map(\.element)
    }

    var pendingImports: [PendingImport] {
        importManager.pendingImports
    }

    var isEmpty: Bool {
        permits.isEmpty && pendingImports.isEmpty
    }

    var filteredPermits: [Permit] {
        permits.filter { matches($0, filter: selectedFilter) }
    }

    func count(for filter: PermitFilter) -> Int {
        permits.filter { matches($0, filter: filter) }.count
    }

    func importTapped() {
        isFilePickerPresented = true
    }

    func filesPicked(_ result: Result<[URL], any Error>) async {
        guard case .success(let urls) = result, !urls.isEmpty else { return }
        guard urls.count > 1 else {
            await importManager.importPDFs(at: urls)
            return
        }
        pickedURLs = urls
        isGroupingChoicePresented = true
    }

    func importAsOnePermit() async {
        let urls = takePickedURLs()
        await importManager.importPDFs(at: urls)
    }

    func importAsSeparatePermits() async {
        let urls = takePickedURLs()
        await withTaskGroup(of: Void.self) { group in
            for url in urls {
                group.addTask { await self.importManager.importPDFs(at: [url]) }
            }
        }
    }

    func cancelGroupingChoice() {
        pickedURLs = []
    }

    private func takePickedURLs() -> [URL] {
        defer { pickedURLs = [] }
        return pickedURLs
    }

    func retry(_ pendingImport: PendingImport) async {
        await importManager.retry(pendingImport)
    }

    func remove(_ pendingImport: PendingImport) {
        importManager.remove(pendingImport)
    }

    func sharedFileArrived() {
        selectedBrief = nil
    }

    func highlightImported() async {
        guard let id = importManager.lastImportedID else { return }
        highlightedPermitID = id
        try? await Task.sleep(for: .seconds(2))
        if highlightedPermitID == id {
            highlightedPermitID = nil
        }
    }

    func isReloading(_ permit: Permit) -> Bool {
        importManager.reloadingIDs.contains(permit.id)
    }

    func select(_ permit: Permit) {
        guard !isReloading(permit) else { return }
        selectedBrief = permitManager.brief(for: permit.id)
    }

    func delete(_ permit: Permit) {
        try? permitManager.delete(id: permit.id)
    }

    func tryDemoTapped() {
        selectedBrief = .demo
    }

    private func matches(_ permit: Permit, filter: PermitFilter) -> Bool {
        switch filter {
        case .all:
            return true
        case .active:
            return permit.status == .active
        case .expired:
            return permit.status == .expired
        }
    }
}
