//
//  NetworkDataHandlerMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 26/3/22.
//

@testable import Data
import Domain
import Foundation
import XCTest

class NetworkDataHandlerMock: NetworkDataHandler {
    private var handleCallCount = 0

    func handle<T: DataObject>(_: Data?) throws -> DataWrapper<T> {
        handleCallCount += 1
        return DataWrapper<T>.empty
    }

    func assertHandle(callCount: Int, file _: StaticString = #filePath, line _: UInt = #line) {
        XCTAssertEqual(handleCallCount, callCount)
    }
}

class NetworkDataHandlerFailingStub: NetworkDataHandlerMock {
    override func handle<T: DataObject>(_ data: Data?) throws -> DataWrapper<T> {
        let _: DataWrapper<T> = try super.handle(data)
        throw DataServiceError.emptyData
    }
}
