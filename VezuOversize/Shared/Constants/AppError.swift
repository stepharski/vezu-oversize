import Foundation

enum AppError: String, Error {
    case invalidURL = "Invalid URL. Please try again."
    case invalidResponse = "Invalid response from server. Please try again."
    case invalidData = "The data received from server is invalid. Please try again."
    case networkError = "Unable to complete your request. Please check your internet connection."
    case unauthorized = "This version of VEZU can't reach the permit reader. Please update the app."
    case rateLimited = "Too many permits are being read right now. Please wait a minute and try again."
    case filesTooLarge = "These files are too large. A permit must be under 10 MB in total."
    case tooManyFiles = "A permit can have up to 5 files."
    case unreadableFile = "This file couldn't be opened. Please try another PDF."
    case unreadablePermit = "This permit couldn't be read. Make sure the PDF is an oversize permit."
    case notAPermit = "This doesn't look like an oversize permit. Only permit PDFs can be read."
}
