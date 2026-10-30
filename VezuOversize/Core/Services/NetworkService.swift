import Foundation

protocol NetworkServicable {
    func request<T: Decodable & Sendable>(_ route: APIPath, responseModel: T.Type) async throws -> T
}

struct NetworkService {
    private let session: URLSession
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    init(session: URLSession = .shared) {
        self.session = session
    }

    private func perform(_ route: APIPath) async throws -> Data {
        let request = try makeRequest(route)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw AppError.networkError
        }

        guard let response = response as? HTTPURLResponse else {
            throw AppError.invalidResponse
        }
        guard (200...299).contains(response.statusCode) else {
            throw appError(statusCode: response.statusCode, data: data)
        }
        return data
    }

    private func appError(statusCode: Int, data: Data) -> AppError {
        let errorCode = try? decoder.decode(ErrorResponse.self, from: data).error

        switch (statusCode, errorCode) {
        case (401, _), (_, NetworkConstants.ErrorCode.unauthorized):
            return .unauthorized
        case (429, _), (_, NetworkConstants.ErrorCode.rateLimited):
            return .rateLimited
        case (_, NetworkConstants.ErrorCode.pdfTooLarge):
            return .filesTooLarge
        case (_, NetworkConstants.ErrorCode.tooManyFiles):
            return .tooManyFiles
        case (_, NetworkConstants.ErrorCode.notAPermit):
            return .notAPermit
        case (_, NetworkConstants.ErrorCode.refused), (_, NetworkConstants.ErrorCode.truncated),
             (_, NetworkConstants.ErrorCode.unparseableOutput):
            return .unreadablePermit
        default:
            return .invalidResponse
        }
    }

    private func makeRequest(_ route: APIPath) throws -> URLRequest {
        guard let url = URL(string: route.baseURL + route.path) else {
            throw AppError.invalidURL
        }

        var request = URLRequest(url: url, timeoutInterval: NetworkConstants.requestTimeout)
        request.httpMethod = route.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(route.appToken, forHTTPHeaderField: NetworkConstants.HeaderKey.appToken)

        if let body = route.body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try encoder.encode(body)
        }

        return request
    }
}

extension NetworkService: NetworkServicable {
    func request<T: Decodable & Sendable>(_ route: APIPath, responseModel: T.Type) async throws -> T {
        let data = try await perform(route)
        do {
            return try decoder.decode(responseModel, from: data)
        } catch {
            throw AppError.invalidData
        }
    }
}

private extension NetworkService {
    struct ErrorResponse: Decodable {
        let error: String
    }
}
