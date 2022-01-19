//
//  ImageDataTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import XCTest
@testable import Marvel

class ImageDataTests: XCTestCase, ParsingTester {

    typealias ParseableObjectType = ImageData

    func test_givenImageDataFromJson_parsesExpectedValues() throws {
        let actual = givenParsedObjectFromJson()
        let expected = ImageData(
            path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
            imageExtension: "jpg"
        )
        XCTAssertEqual(actual, expected)
    }
}
