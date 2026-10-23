import Foundation

protocol PermitFileServicable {
    func save(_ sourceURL: URL, id: UUID, index: Int) throws -> String
    func url(for fileName: String) throws -> URL
    func data(for fileName: String) throws -> Data
    func delete(_ fileName: String)
}

struct PermitFileService {
    private let fileManager = FileManager.default

    private func directory() throws -> URL {
        let directory = URL.applicationSupportDirectory.appending(path: "Permits", directoryHint: .isDirectory)
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }
}

extension PermitFileService: PermitFileServicable {
    func save(_ sourceURL: URL, id: UUID, index: Int) throws -> String {
        let fileName = index == 0 ? "\(id.uuidString).pdf" : "\(id.uuidString)-\(index).pdf"
        let destination = try url(for: fileName)

        if fileManager.fileExists(atPath: destination.path(percentEncoded: false)) {
            try fileManager.removeItem(at: destination)
        }
        try fileManager.copyItem(at: sourceURL, to: destination)
        return fileName
    }

    func url(for fileName: String) throws -> URL {
        try directory().appending(path: fileName)
    }

    func data(for fileName: String) throws -> Data {
        try Data(contentsOf: url(for: fileName))
    }

    func delete(_ fileName: String) {
        guard let url = try? url(for: fileName) else { return }
        try? fileManager.removeItem(at: url)
    }
}
