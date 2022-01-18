//
//  DataWrapperTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 18/1/22.
//

import XCTest
@testable import Marvel

class DataWrapperTests: XCTestCase, ParsingTester {

    typealias ParseableObjectType = DataWrapper

    func test_givenDataWrapperFromJson_parsesExpectedValues() throws {
        let actual = givenParsedObjectFromJson()
        let expected = DataWrapper(code: 200, status: "Ok", copyright: "© 2022 MARVEL")
        XCTAssertEqual(actual, expected)
    }
}
