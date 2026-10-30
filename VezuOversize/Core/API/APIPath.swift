import Foundation

enum HTTPMethod: String {
    case post = "POST"
}

enum APIPath: Equatable {
    case summarizePermit(request: SummarizePermitRequest)
    case routePermit(request: SummarizePermitRequest)
    case leadIns(request: LeadInRequest)
    case places(request: PlacesRequest)

    var method: HTTPMethod {
        switch self {
        case .summarizePermit, .routePermit, .leadIns, .places:
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
        case .routePermit:
            return NetworkConstants.Path.routePermit
        case .leadIns:
            return NetworkConstants.Path.leadIns
        case .places:
            return NetworkConstants.Path.places
        }
    }

    var body: (any Encodable)? {
        switch self {
        case .summarizePermit(let request), .routePermit(let request):
            return request
        case .leadIns(let request):
            return request
        case .places(let request):
            return request
        }
    }

    var appToken: String {
        Secrets.appToken
    }
}
