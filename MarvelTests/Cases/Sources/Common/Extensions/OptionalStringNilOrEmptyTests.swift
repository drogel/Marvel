//
//  OptionalStringNilOrEmptyTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 3/2/22.
//

@testable import Marvel_Debug
import XCTest

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
