//
//  ImageDataTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import XCTest
@testable import Marvel_Debug

class ImageDataTests: XCTestCase {

    typealias ParseableObjectType = ImageData

    func test_givenImageDataFromJson_parsesExpectedValues() {
        runParsingTest()
    }
}

extension ImageDataTests: ParsingTestCaseTemplate {

    func buildExpectedObject() -> ImageData {
        ImageData(
            path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
            imageExtension: "jpg"
        )
    }
}
