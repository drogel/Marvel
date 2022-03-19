//
//  NetworkServiceMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 29/1/22.
//

import Foundation
@testable import Marvel_Debug

class NetworkServiceMock: NetworkService {
    var requestCallCount = 0

    func request(endpoint _: RequestComponents, completion _: @escaping NetworkServiceCompletion) -> Disposable? {
        requestCallCount += 1
        return DisposableMock()
    }

    func request(endpoint _: RequestComponents) async throws -> Data? {
        requestCallCount += 1
        return nil
    }
}

class NetworkServiceSuccessfulStub: NetworkServiceMock {
    override func request(endpoint: RequestComponents, completion: @escaping NetworkServiceCompletion) -> Disposable? {
        let result = super.request(endpoint: endpoint, completion: completion)
        completion(.success(Data()))
        return result
    }

    override func request(endpoint: RequestComponents) async throws -> Data? {
        _ = try await super.request(endpoint: endpoint)
        return Data()
    }
}

class NetworkServiceFailingStub: NetworkServiceMock {
    private let errorStub: NetworkError

    init(errorStub: NetworkError) {
        self.errorStub = errorStub
    }

    override func request(endpoint: RequestComponents, completion: @escaping NetworkServiceCompletion) -> Disposable? {
        let result = super.request(endpoint: endpoint, completion: completion)
        completion(.failure(errorStub))
        return result
    }

    override func request(endpoint _: RequestComponents) async throws -> Data? {
        throw errorStub
    }
}

class NetworkServiceRequestCacheFake: NetworkServiceMock {
    var cachedComponents: RequestComponents?

    override func request(endpoint: RequestComponents, completion: @escaping NetworkServiceCompletion) -> Disposable? {
        cachedComponents = endpoint
        return super.request(endpoint: endpoint, completion: completion)
    }

    override func request(endpoint: RequestComponents) async throws -> Data? {
        cachedComponents = endpoint
        return try await super.request(endpoint: endpoint)
    }
}
