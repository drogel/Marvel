//
//  CharacterDataMapperTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 13/2/22.
//

@testable import Marvel_Debug
import XCTest

class CharacterDataMapperTests: XCTestCase {
    private var sut: CharacterDataMapper!
    private var imageMapper: ImageMapper!

    override func setUp() {
        super.setUp()
        imageMapper = ImageDataMapper()
        sut = CharacterDataMapper(imageMapper: imageMapper)
    }

    override func tearDown() {
        sut = nil
        imageMapper = nil
        super.tearDown()
    }

    func test_givenValidCharacterData_mapsToExpectedCharacter() throws {
        let characterData = CharacterData.aginar
        let expectedCharacter = buildExpectedMappedCharacter(from: characterData)
        let actualCharacter = try XCTUnwrap(sut.mapToCharacter(characterData))
        XCTAssertEqual(actualCharacter, expectedCharacter)
    }

    func test_givenNotValidCharacterData_returnsNil() throws {
        let characterData = CharacterData.empty
        let actualCharacter = sut.mapToCharacter(characterData)
        XCTAssertNil(actualCharacter)
    }
}

private extension CharacterDataMapperTests {
    func buildExpectedMappedCharacter(from characterData: CharacterData) -> Character {
        Character(
            identifier: characterData.identifier!,
            name: characterData.name!,
            description: characterData.description!,
            image: imageMapper.mapToImage(characterData.thumbnail!)!
        )
    }
}
