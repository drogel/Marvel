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

    func request(endpoint: RequestComponents, completion: @escaping NetworkServiceCompletion) -> Cancellable? {
        requestCallCount += 1
        return CancellableMock()
    }
}

class NetworkServiceSuccessfulStub: NetworkServiceMock {

    override func request(endpoint: RequestComponents, completion: @escaping NetworkServiceCompletion) -> Cancellable? {
        let result = super.request(endpoint: endpoint, completion: completion)
        completion(.success(Data()))
        return result
    }
}

class NetworkServiceFailingStub: NetworkServiceMock {

    private let errorStub: NetworkError

    init(errorStub: NetworkError) {
        self.errorStub = errorStub
    }

    override func request(endpoint: RequestComponents, completion: @escaping NetworkServiceCompletion) -> Cancellable? {
        let result = super.request(endpoint: endpoint, completion: completion)
        completion(.failure(errorStub))
        return result
    }
}

