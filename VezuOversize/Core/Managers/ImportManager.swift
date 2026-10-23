import Foundation
import UIKit

@Observable
final class ImportManager {
    private(set) var pendingImports: [PendingImport] = []
    private(set) var lastImportedID: UUID?
    private(set) var errorMessage: String?
    private(set) var errorTitle = AppText.PermitImport.errorTitle
    // Saved permits being read again; their rows show "Reloading…" and can't be opened.
    private(set) var reloadingIDs: Set<UUID> = []

    private let permitManager: PermitManager
    private let permitService: PermitServicable
    private let fileService: PermitFileServicable
    // Saved copies and their contents, kept until the read succeeds so Retry needs no re-pick.
    private var jobs: [UUID: ImportJob] = [:]

    private struct ImportJob {
        let fileNames: [String]
        let files: [PermitFile]
        // Set for reloads: the record being replaced, which still owns the files.
        var replacingID: UUID?
    }

    init(permitManager: PermitManager,
         permitService: PermitServicable = PermitService(),
         fileService: PermitFileServicable = PermitFileService()) {
        self.permitManager = permitManager
        self.permitService = permitService
        self.fileService = fileService
    }

    // All files belong to one permit, e.g. the permit plus its condition sheets.
    func importPDFs(at urls: [URL]) async {
        guard let firstURL = urls.first else { return }

        errorMessage = nil
        let id = UUID()
        var savedFileNames: [String] = []

        do {
            var files: [PermitFile] = []
            for (index, url) in urls.enumerated() {
                let fileName = try save(url, id: id, index: index)
                savedFileNames.append(fileName)
                let data = try fileService.data(for: fileName)
                files.append(PermitFile(name: url.lastPathComponent, base64: data.base64EncodedString()))
            }

            jobs[id] = ImportJob(fileNames: savedFileNames, files: files)
            pendingImports.insert(
                PendingImport(
                    id: id,
                    fileName: firstURL.deletingPathExtension().lastPathComponent,
                    fileCount: urls.count,
                    state: .reading),
                at: 0)
            await read(id)
        } catch {
            savedFileNames.forEach(fileService.delete)
            handleFailure(error)
        }
    }

    // Reads a saved permit again from its own PDF copies, e.g. after the reader improves.
    func reload(_ brief: PermitBrief) async {
        guard let recordID = permitManager.recordID(for: brief), !reloadingIDs.contains(recordID) else { return }
        let fileNames = permitManager.savedFileNames(for: brief)

        do {
            guard !fileNames.isEmpty else { throw AppError.unreadableFile }
            let files = try fileNames.enumerated().map { index, fileName in
                PermitFile(
                    name: index == 0 ? AppText.PermitImport.permitFileName : AppText.PermitImport.attachmentFileName(index),
                    base64: try fileService.data(for: fileName).base64EncodedString())
            }

            let id = UUID()
            jobs[id] = ImportJob(fileNames: fileNames, files: files, replacingID: recordID)
            reloadingIDs.insert(recordID)
            await read(id)
        } catch {
            handleFailure(error, title: AppText.PermitImport.reloadErrorTitle)
        }
    }

    func retry(_ pendingImport: PendingImport) async {
        guard !pendingImport.isReading else { return }
        await read(pendingImport.id)
    }

    func remove(_ pendingImport: PendingImport) {
        jobs.removeValue(forKey: pendingImport.id)?.fileNames.forEach(fileService.delete)
        pendingImports.removeAll { $0.id == pendingImport.id }
    }

    func dismissError() {
        errorMessage = nil
    }

    private func read(_ id: UUID) async {
        guard let job = jobs[id] else { return }
        setState(.reading, for: id)

        // Extra time from iOS so switching apps mid-read doesn't cancel the request.
        let backgroundTask = UIApplication.shared.beginBackgroundTask()
        defer { UIApplication.shared.endBackgroundTask(backgroundTask) }

        do {
            let brief = try await permitService.summarize(job.files)
            try permitManager.add(brief, id: id, pdfFileNames: job.fileNames, replacing: job.replacingID)
            jobs[id] = nil
            pendingImports.removeAll { $0.id == id }
            lastImportedID = id
        } catch {
            if job.replacingID != nil {
                // The saved permit is untouched, so a failed reload only needs a message.
                jobs[id] = nil
                handleFailure(error, title: AppText.PermitImport.reloadErrorTitle)
            } else {
                setState(.failed((error as? AppError ?? .unreadablePermit).rawValue), for: id)
            }
        }
        if let replacingID = job.replacingID {
            reloadingIDs.remove(replacingID)
        }
    }

    private func setState(_ state: PendingImport.State, for id: UUID) {
        guard let index = pendingImports.firstIndex(where: { $0.id == id }) else { return }
        pendingImports[index].state = state
    }

    private func save(_ url: URL, id: UUID, index: Int) throws -> String {
        let isAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if isAccessing { url.stopAccessingSecurityScopedResource() }
        }

        let fileName: String
        do {
            fileName = try fileService.save(url, id: id, index: index)
        } catch {
            throw AppError.unreadableFile
        }
        removeFromInbox(url)
        return fileName
    }

    // Files shared from other apps arrive in the Inbox folder; the saved copy replaces them.
    private func removeFromInbox(_ url: URL) {
        guard url.pathComponents.contains("Inbox") else { return }
        try? FileManager.default.removeItem(at: url)
    }

    private func handleFailure(_ error: Error, title: String = AppText.PermitImport.errorTitle) {
        errorTitle = title
        errorMessage = (error as? AppError ?? .unreadableFile).rawValue
    }
}
