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

    override func setUp() {
        super.setUp()
        givenSutWithEmptyDataLoader()
    }

    override func tearDown() {
        sut = nil
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

    func test_givenDidAlreadyLoad_whenRetrievingCharacters_disposableIsNil() {
        givenDidAlreadyLoad()
        XCTAssertNil(sut.characters(from: 0, completion: { _ in }))
    }
}

private extension CharactersDebugServiceTests {
    func givenSutWithDataLoader() {
        let jsonDataLoader = JsonDataLoaderStub<CharacterData>()
        givenSut(with: jsonDataLoader)
    }

    func givenSutWithEmptyDataLoader() {
        let jsonDataLoader = JsonDataLoaderEmptyStub()
        givenSut(with: jsonDataLoader)
    }

    func givenSut(with dataLoader: JsonDataLoader) {
        sut = CharactersDebugService(
            dataLoader: dataLoader,
            dataResultHandler: CharacterDataResultHandlerFactory.createWithDataMappers()
        )
    }

    func givenDidAlreadyLoad() {
        givenSutWithDataLoader()
        _ = whenRetrievingResultFromCharacters()
    }

    func whenRetrievingResultFromCharacters(externalExpectation: XCTestExpectation? = nil) -> CharactersServiceResult {
        let defaultExpectation = expectation(description: "JSON file parsing completion")
        let completionExpectation = externalExpectation ?? defaultExpectation
        var completionResult: CharactersServiceResult!
        _ = sut.characters(from: 0) { result in
            completionResult = result
            completionExpectation.fulfill()
        }
        wait(for: [completionExpectation], timeout: 0.1)
        return completionResult
    }
}
