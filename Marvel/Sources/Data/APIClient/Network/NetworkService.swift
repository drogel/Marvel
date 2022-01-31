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
    func request(endpoint: RequestComponents, completion: @escaping NetworkServiceCompletion) -> Cancellable?
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

    func request(endpoint: RequestComponents, completion: @escaping NetworkServiceCompletion) -> Cancellable? {
        guard let urlRequest = buildURLRequest(from: endpoint) else {
            completion(.failure(.invalidURL))
            return nil
        }
        return request(request: urlRequest, completion: completion)
    }
}

private extension NetworkSessionService {
    func buildURLRequest(from components: RequestComponents) -> URLRequest? {
        guard let url = urlComposer.compose(from: baseURL, adding: components) else { return nil }
        return URLRequest(url: url)
    }

    func request(request: URLRequest, completion: @escaping NetworkServiceCompletion) -> Cancellable {
        let sessionDataTask = session.loadData(from: request) { [weak self] data, response, requestError in
            DispatchQueue.main.async {
                self?.handleDataLoaded(data, response: response, error: requestError, completion: completion)
            }
        }
        sessionDataTask.resume()
        return sessionDataTask
    }

    func handleDataLoaded(_ data: Data?, response: URLResponse?, error: Error?, completion: @escaping NetworkServiceCompletion) {
        if let networkError = findNetworkError(in: response, with: error) {
            handle(networkError, completion: completion)
        } else {
            handleSuccess(data, completion: completion)
        }
    }

    func handleSuccess(_ data: Data?, completion: @escaping NetworkServiceCompletion) {
        completion(.success(data))
    }

    func handle(_ networkError: NetworkError, completion: @escaping NetworkServiceCompletion) {
        completion(.failure(networkError))
    }

    func findNetworkError(in response: URLResponse?, with requestError: Error?) -> NetworkError? {
        if let response = response as? HTTPURLResponse, (400 ..< 600).contains(response.statusCode) {
            return statusCodeBasedError(for: response.statusCode)
        } else if let urlError = requestError as? URLError {
            return parseToNetworkError(urlError)
        } else if let error = requestError {
            return .requestError(error)
        } else {
            return nil
        }
    }

    func parseToNetworkError(_ urlError: URLError) -> NetworkError {
        if urlError.code == .notConnectedToInternet {
            return .notConnected
        } else if urlError.code == .cancelled {
            return .cancelled
        } else {
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
