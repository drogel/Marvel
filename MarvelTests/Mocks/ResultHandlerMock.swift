//
//  ResultHandlerMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 7/2/22.
//

import Foundation
@testable import Marvel_Debug

class ResultHandlerMock: ResultHandler {
    var handleCallCount = 0

    func handle<T: DataObject>(
        result _: Result<Data?, NetworkError>,
        completion _: @escaping (DataServiceResult<T>) -> Void
    ) {
        handleCallCount += 1
    }
}
