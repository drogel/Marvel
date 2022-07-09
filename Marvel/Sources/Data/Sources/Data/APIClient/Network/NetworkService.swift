//
//  NetworkService.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

public enum NetworkError: Error {
    case statusCodeError(statusCode: Int)
    case invalidURL
    case notConnected
    case cancelled
    case unauthorized
    case requestError(Error?)
}

public protocol NetworkService {
    func request(endpoint: RequestComponents) async throws -> Data?
}

class NetworkSessionService: NetworkService {
    private let session: NetworkSession
    private let baseURL: URL
    private let urlComposer: URLComposer

    init(session: NetworkSession, baseURL: URL, urlComposer: URLComposer) {
        self.session = session
        self.baseURL = baseURL
        self.urlComposer = urlComposer
    }

    func request(endpoint: RequestComponents) async throws -> Data? {
        guard let urlRequest = buildURLRequest(from: endpoint) else { throw NetworkError.invalidURL }
        return try await loadDataHandlingErrors(from: urlRequest)
    }
}

private extension NetworkSessionService {
    func buildURLRequest(from components: RequestComponents) -> URLRequest? {
        guard let url = urlComposer.compose(from: baseURL, adding: components) else { return nil }
        return URLRequest(url: url)
    }

    func loadDataHandlingErrors(from urlRequest: URLRequest) async throws -> Data {
        do {
            return try await loadData(from: urlRequest)
        } catch let error as NetworkError {
            throw error
        } catch {
            guard let networkError = findNetworkError(in: error) else { throw NetworkError.requestError(error) }
            throw networkError
        }
    }

    func loadData(from urlRequest: URLRequest) async throws -> Data {
        let responseWithData = try await session.loadData(from: urlRequest)
        if let networkError = findNetworkError(in: responseWithData.response) { throw networkError }
        return responseWithData.data
    }

    func findNetworkError(in response: URLResponse) -> NetworkError? {
        let invalidResponseRange = (400 ..< 600)
        guard let response = response as? HTTPURLResponse,
              invalidResponseRange.contains(response.statusCode)
        else { return nil }
        return statusCodeBasedError(for: response.statusCode)
    }

    func findNetworkError(in requestError: Error) -> NetworkError? {
        switch requestError {
        case let urlError as URLError:
            return parseToNetworkError(urlError)
        default:
            return nil
        }
    }

    func parseToNetworkError(_ urlError: URLError) -> NetworkError {
        switch urlError.code {
        case .notConnectedToInternet:
            return .notConnected
        case .cancelled:
            return .cancelled
        default:
            return .requestError(urlError)
        }
    }

    func statusCodeBasedError(for statusCode: Int) -> NetworkError {
        switch statusCode {
        case 401:
            return .unauthorized
        default:
            return .statusCodeError(statusCode: statusCode)
        }
    }
}
