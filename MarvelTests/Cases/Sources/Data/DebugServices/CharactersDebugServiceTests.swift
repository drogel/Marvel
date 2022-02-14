//
//  CharactersDebugServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

@testable import Marvel_Debug
import XCTest

class CharactersDebugServiceTests: XCTestCase {
    private var sut: CharactersDebugService!
    private var jsonDataLoaderCode: Int!

    override func setUp() {
        super.setUp()
        givenSutWithEmptyDataLoader()
    }

    override func tearDown() {
        sut = nil
        jsonDataLoaderCode = nil
        super.tearDown()
    }

    func test_conformsToCharactersService() {
        XCTAssertTrue((sut as AnyObject) is CharactersService)
    }

    func test_whenRetrievingCharacters_returnsNil() {
        XCTAssertNil(sut.characters(from: 0, completion: { _ in }))
    }

    func test_givenSutWithEmptyDataLoader_whenRetrievingCharacters_completesWithFailure() {
        givenSutWithEmptyDataLoader()
        let completionResult = whenRetrievingResultFromCharacters()
        assertIsFailure(completionResult)
    }

    func test_givenSutDataLoader_whenRetrievingCharacters_completesWithSuccess() {
        givenSutWithDataLoader()
        let completionResult = whenRetrievingResultFromCharacters()
        assertIsSuccess(completionResult)
    }
}

private extension CharactersDebugServiceTests {
    func givenSutWithDataLoader() {
        let jsonDataLoader = JsonDataLoaderStub<CharacterData>()
        jsonDataLoaderCode = jsonDataLoader.codeStub
        givenSut(with: jsonDataLoader)
    }

    func givenSutWithEmptyDataLoader() {
        let jsonDataLoader = JsonDataLoaderEmptyStub()
        givenSut(with: jsonDataLoader)
    }

    func givenSut(with dataLoader: JsonDataLoader) {
        sut = CharactersDebugService(
            dataLoader: dataLoader,
            characterMapper: CharacterDataMapper(imageMapper: ImageDataMapper()),
            pageMapper: PageDataMapper()
        )
    }

    func whenRetrievingResultFromCharacters() -> CharactersServiceResult {
        var completionResult: CharactersServiceResult!
        let expectation = expectation(description: "JSON file parsing completion")
        _ = sut.characters(from: 0) { result in
            completionResult = result
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        return completionResult
    }
}
