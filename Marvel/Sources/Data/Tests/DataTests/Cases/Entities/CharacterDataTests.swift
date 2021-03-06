//
//  CharacterDataTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

@testable import Data
import TestUtils
import XCTest

class CharacterDataTests: XCTestCase {
    typealias ParseableObjectType = CharacterData

    func test_givenCharacterDataFromJson_parsesExpectedValues() throws {
        try runParsingTest()
    }
}

extension CharacterDataTests: ParsingTestCaseTemplate {
    func buildExpectedObject() -> CharacterData {
        let imageData = buildExpectedImageData()
        return buildExpectedCharacterData(with: imageData)
    }
}

private extension CharacterDataTests {
    func buildExpectedImageData() -> ImageData {
        let imageData = ImageData(
            path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
            imageExtension: "jpg"
        )
        return imageData
    }

    func buildExpectedCharacterData(with imageData: ImageData) -> CharacterData {
        let characterData = CharacterData(
            identifier: 1_011_334,
            name: "3-D Man",
            description: "",
            modified: "2014-04-29T14:18:17-0400",
            thumbnail: imageData,
            resourceURI: "http://gateway.marvel.com/v1/public/characters/1011334"
        )
        return characterData
    }
}
