//
//  Publisher+Assertions.swift
//  MarvelTests
//
//  Created by Diego Rogel on 10/3/22.
//

import Combine
import XCTest

extension Publisher where Output: Equatable, Failure == Never {
    func assertOutput(
        matches expectedValues: [Output],
        expectation: XCTestExpectation,
        file _: StaticString = #filePath,
        line _: UInt = #line
    ) -> AnyCancellable {
        var copiedExpectedValues = expectedValues
        return sink { receivedValue in
            guard let expectedValue = copiedExpectedValues.first else {
                XCTFail("The publisher emitted more values than expected.")
                return
            }
            guard expectedValue == receivedValue else {
                XCTFail("Expected received value \(receivedValue) to match first expected value \(expectedValue)")
                return
            }
            copiedExpectedValues = Array(expectedValues.dropFirst())
            if copiedExpectedValues.isEmpty {
                expectation.fulfill()
            }
        }
    }

    func assertOutput(
        matches expectedValue: Output,
        expectation: XCTestExpectation,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> AnyCancellable {
        sink { receivedValue in
            XCTAssertEqual(receivedValue, expectedValue, file: file, line: line)
            expectation.fulfill()
        }
    }
}
