import Foundation

enum HTTPMethod: String {
    case post = "POST"
}

enum APIPath: Equatable {
    case summarizePermit(request: SummarizePermitRequest)

    var method: HTTPMethod {
        switch self {
        case .summarizePermit:
            return .post
        }
    }

    var baseURL: String {
        NetworkConstants.baseURL
    }

    var path: String {
        switch self {
        case .summarizePermit:
            return NetworkConstants.Path.summarizePermit
        }
    }

    var body: (any Encodable)? {
        switch self {
        case let .summarizePermit(request):
            return request
        }
    }

    var appToken: String {
        Secrets.appToken
    }
}
