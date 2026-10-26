import Foundation

enum NetworkConstants {
    static let baseURL = "https://vezu-permits.stepharski.workers.dev"
    static let requestTimeout: TimeInterval = 120

    enum Path {
        static let summarizePermit = "/"
        static let routePermit = "/route"
        static let leadIns = "/leadins"
        static let places = "/places"
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
        static let notAPermit = "not_a_permit"
    }
}
