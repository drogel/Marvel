//
//  AuthenticatedNetworkService.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

class AuthenticatedNetworkService: NetworkService {

    private let networkService: NetworkService
    private let authenticator: Authenticator

    init(networkService: NetworkService, authenticator: Authenticator) {
        self.networkService = networkService
        self.authenticator = authenticator
    }

    func request(endpoint: RequestComponents, completion: @escaping NetworkServiceCompletion) -> Cancellable? {
        guard let authenticatedComponents = addAuthentication(to: endpoint) else {
            completion(.failure(.unauthorized))
            return nil
        }
        return networkService.request(endpoint: authenticatedComponents, completion: completion)
    }
}

private extension AuthenticatedNetworkService {

    var nowTimestamp: TimeInterval {
        Date().timeIntervalSince1970
    }

    func addAuthentication(to components: RequestComponents) -> RequestComponents? {
        guard let authenticationQueryParameters = authenticator.authenticate(with: nowTimestamp) else { return nil }
        let authenticatedQuery = components.queryParameters.merging(authenticationQueryParameters) { (_, new) in new }
        return RequestComponents(path: components.path, queryParameters: authenticatedQuery)
    }
}
