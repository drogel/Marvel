//
//  NetworkService.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

enum NetworkError: Error {
    case errorStatusCode(statusCode: Int)
    case invalidURL
    case notConnected
    case cancelled
    case requestError(Error?)
}

typealias NetworkServiceCompletion = (Result<Data?, NetworkError>) -> Void

protocol NetworkService {
    func request(endpoint: Requestable, completion: @escaping NetworkServiceCompletion) -> Cancellable?
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

    func request(endpoint: Requestable, completion: @escaping NetworkServiceCompletion) -> Cancellable? {
        guard let urlRequest = buildURLRequest(from: endpoint) else {
            completion(.failure(.invalidURL))
            return nil
        }
        return request(request: urlRequest, completion: completion)
    }
}

private extension NetworkSessionService {

    func buildURLRequest(from requestable: Requestable) -> URLRequest? {
        guard let url = urlComposer.compose(from: baseURL, adding: requestable) else { return nil }
        return URLRequest(url: url)
    }

    func request(request: URLRequest, completion: @escaping NetworkServiceCompletion) -> Cancellable {
        let sessionDataTask = session.loadData(from: request) { [weak self] (data, response, requestError) in
            DispatchQueue.main.async { self?.handleDataLoaded(data, response: response, error: requestError, completion: completion) }
        }
        sessionDataTask.resume()
        return sessionDataTask
    }

    func handleDataLoaded(_ data: Data?, response: URLResponse?, error: Error?, completion: @escaping NetworkServiceCompletion) {
        if let requestError = error {
            handle(requestError, in: response, completion: completion)
        } else {
            handleSuccess(data, completion: completion)
        }
    }

    func handleSuccess(_ data: Data?, completion: @escaping NetworkServiceCompletion) {
        completion(.success(data))
    }

    func handle(_ requestError: Error, in response: URLResponse?, completion: @escaping NetworkServiceCompletion) {
        let networkError = parseToNetworkError(requestError, in: response)
        completion(.failure(networkError))
    }

    func parseToNetworkError(_ requestError: Error, in response: URLResponse?) -> NetworkError {
        if let response = response as? HTTPURLResponse, (400..<600).contains(response.statusCode) {
            return .errorStatusCode(statusCode: response.statusCode)
        } else if let urlError = requestError as? URLError {
            return parseToNetworkError(urlError)
        } else {
            return .requestError(requestError)
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
}
