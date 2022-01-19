//
//  CharacterDataTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import XCTest
@testable import Marvel

class CharacterDataTests: XCTestCase, ParsingTester {

    typealias ParseableObjectType = CharacterData

    func test_givenCharacterDataFromJson_parsesExpectedValues() throws {
        let actual = givenParsedObjectFromJson()
        let imageData = ImageData(
            path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
            imageExtension: "jpg"
        )
        let expected = CharacterData(
            id: 1011334,
            name: "3-D Man",
            description: "",
            modified: "2014-04-29T14:18:17-0400",
            thumbnail: imageData,
            resourceURI: "http://gateway.marvel.com/v1/public/characters/1011334"
        )
        XCTAssertEqual(actual, expected)
    }
}
