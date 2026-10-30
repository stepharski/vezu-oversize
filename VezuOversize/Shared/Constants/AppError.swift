import Foundation

enum AppError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case networkError
    case unauthorized
    case rateLimited
    case filesTooLarge
    case tooManyFiles
    case unreadableFile
    case unreadablePermit
    case notAPermit

    var message: String {
        switch self {
        case .invalidURL:
            return String(localized: "Invalid URL. Please try again.")
        case .invalidResponse:
            return String(localized: "Invalid response from server. Please try again.")
        case .invalidData:
            return String(localized: "The data received from server is invalid. Please try again.")
        case .networkError:
            return String(localized: "Unable to complete your request. Please check your internet connection.")
        case .unauthorized:
            return String(localized: "This version of VEZU can't reach the permit reader. Please update the app.")
        case .rateLimited:
            return String(localized: "Too many permits are being read right now. Please wait a minute and try again.")
        case .filesTooLarge:
            return String(localized: "These files are too large. A permit must be under 10 MB in total.")
        case .tooManyFiles:
            return String(localized: "A permit can have up to 5 files.")
        case .unreadableFile:
            return String(localized: "This file couldn't be opened. Please try another PDF.")
        case .unreadablePermit:
            return String(localized: "This permit couldn't be read. Make sure the PDF is an oversize permit.")
        case .notAPermit:
            return String(localized: "This doesn't look like an oversize permit. Only permit PDFs can be read.")
        }
    }
}
