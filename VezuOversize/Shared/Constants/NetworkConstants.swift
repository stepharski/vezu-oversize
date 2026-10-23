import Foundation

enum NetworkConstants {
    static let baseURL = "https://vezu-permits.stepharski.workers.dev"
    // Reading a permit takes 10–60 seconds, longer when the server double-checks it.
    static let requestTimeout: TimeInterval = 120

    enum Path {
        static let summarizePermit = "/"
    }

    enum HeaderKey {
        static let appToken = "X-App-Token"
    }

    enum ErrorCode {
        static let unauthorized = "unauthorized"
        static let rateLimited = "rate_limited"
        static let pdfTooLarge = "pdf_too_large"
        static let tooManyFiles = "too_many_files"
        static let refused = "refused"
        static let truncated = "truncated"
        static let unparseableOutput = "unparseable_output"
    }
}
