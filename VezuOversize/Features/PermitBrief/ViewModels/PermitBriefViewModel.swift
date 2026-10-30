import Foundation

@Observable
final class PermitBriefViewModel {
    let brief: PermitBrief
    var isRoutePresented = false
    var isDeleteConfirmationPresented = false
    var previewURL: URL?

    private(set) var pdfURLs: [URL] = []

    private let permitManager: PermitManager
    private let importManager: ImportManager

    init(brief: PermitBrief, permitManager: PermitManager, importManager: ImportManager) {
        self.brief = brief
        self.permitManager = permitManager
        self.importManager = importManager
    }

    var feeText: String {
        brief.fee.formatted(.currency(code: "USD"))
    }

    var dateRangeText: String {
        brief.validFrom.rangeText(to: brief.validTo, includesYear: true)
    }

    var status: PermitStatus {
        brief.status
    }

    var canDelete: Bool {
        permitManager.contains(brief)
    }

    var hasOriginal: Bool {
        !permitManager.savedFileNames(for: brief).isEmpty
    }

    func didTapRoute() {
        isRoutePresented = true
    }

    func routeViewModel() -> RouteDetailViewModel {
        RouteDetailViewModel(brief: brief, permitManager: permitManager)
    }

    func didTapViewOriginal() {
        pdfURLs = readableCopies(of: permitManager.fileURLs(for: brief))
        previewURL = pdfURLs.first
    }

    func reload() async {
        await importManager.reload(brief)
    }

    func didTapDelete() {
        isDeleteConfirmationPresented = true
    }

    func didConfirmDelete() -> Bool {
        do {
            try permitManager.delete(brief)
            return true
        } catch {
            return false
        }
    }

    private func readableCopies(of urls: [URL]) -> [URL] {
        let folder = URL.temporaryDirectory.appending(path: "Preview", directoryHint: .isDirectory)
        try? FileManager.default.removeItem(at: folder)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        let baseName = "\(brief.stateCode) \(brief.number)"
        return urls.enumerated().map { index, url in
            let name = index == 0 ? "\(baseName).pdf" : "\(baseName) (\(index + 1)).pdf"
            let copy = folder.appending(path: name)
            return (try? FileManager.default.copyItem(at: url, to: copy)) != nil ? copy : url
        }
    }
}
