//
//  NetworkErrorHandlerMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 29/1/22.
//

import Foundation
@testable import Marvel_Debug

class NetworkErroHandlerMock: NetworkErrorHandler {

    var handleCallCount = 0

    private let errorStub: DataServiceError

    init(errorStub: DataServiceError = .emptyData) {
        self.errorStub = errorStub
    }

    func handle(_ networkError: NetworkError) -> DataServiceError {
        handleCallCount += 1
        return errorStub
    }
}