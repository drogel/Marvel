//
//  NetworkService.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

enum NetworkError: Error {
    case statusCodeError(statusCode: Int)
    case invalidURL
    case notConnected
    case cancelled
    case unauthorized
    case requestError(Error?)
}

typealias NetworkServiceCompletion = (Result<Data?, NetworkError>) -> Void

protocol NetworkService {
    func request(endpoint: RequestComponents, completion: @escaping NetworkServiceCompletion) -> Disposable?
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

    func request(endpoint: RequestComponents, completion: @escaping NetworkServiceCompletion) -> Disposable? {
        guard let urlRequest = buildURLRequest(from: endpoint) else {
            completion(.failure(.invalidURL))
            return nil
        }
        Task { await handleDataLoading(from: urlRequest, completion: completion) }
        return nil
    }
}

private extension NetworkSessionService {
    func buildURLRequest(from components: RequestComponents) -> URLRequest? {
        guard let url = urlComposer.compose(from: baseURL, adding: components) else { return nil }
        return URLRequest(url: url)
    }

    func handleDataLoading(from urlRequest: URLRequest, completion: @escaping NetworkServiceCompletion) async {
        do {
            let data = try await loadData(from: urlRequest)
            handleSuccess(data, completion: completion)
        } catch let error as NetworkError {
            handle(networkError: error, completion: completion)
        } catch {
            handle(error, completion: completion)
        }
    }

    func loadData(from urlRequest: URLRequest) async throws -> Data {
        let responseWithData = try await session.loadData(from: urlRequest)
        if let networkError = findNetworkError(in: responseWithData.response) { throw networkError }
        return responseWithData.data
    }

    func handleSuccess(_ data: Data?, completion: @escaping NetworkServiceCompletion) {
        completion(.success(data))
    }

    func handle(networkError: NetworkError, completion: @escaping NetworkServiceCompletion) {
        completion(.failure(networkError))
    }

    func handle(_ genericError: Error, completion: @escaping NetworkServiceCompletion) {
        guard let networkError = findNetworkError(in: genericError) else {
            handle(networkError: .requestError(genericError), completion: completion)
            return
        }
        handle(networkError: networkError, completion: completion)
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
