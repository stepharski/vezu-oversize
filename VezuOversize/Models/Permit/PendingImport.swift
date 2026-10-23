import Foundation

struct PendingImport: Identifiable, Hashable {
    enum State: Hashable {
        case reading
        case failed(String)
    }

    let id: UUID
    let fileName: String
    let fileCount: Int
    var state: State
}

extension PendingImport {
    var isReading: Bool {
        state == .reading
    }

    var errorMessage: String? {
        guard case .failed(let message) = state else { return nil }
        return message
    }
}
