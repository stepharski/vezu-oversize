import Foundation

struct PendingImport: Identifiable, Hashable {
    enum State: Hashable {
        case reading
        case failed(AppError)
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
        guard case .failed(let error) = state else { return nil }
        return error.message
    }

    var canRetry: Bool {
        guard case .failed(let error) = state else { return false }
        return error != .notAPermit
    }
}
