//
//  OptionalStringNilOrEmptyTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 3/2/22.
//

import XCTest
@testable import Marvel_Debug

class OptionalStringNilOrEmptyTests: XCTestCase {

    func test_givenNilString_returnsTrue() {
        let sut: String? = nil
        XCTAssertTrue(sut.isNilOrEmpty)
    }

    func test_givenEmptyString_returnsTrue() {
        let sut: String? = ""
        XCTAssertTrue(sut.isNilOrEmpty)
    }

    func test_givenNonEmptyString_returnsFalse() {
        let sut: String? = "Test"
        XCTAssertFalse(sut.isNilOrEmpty)
    }
}
