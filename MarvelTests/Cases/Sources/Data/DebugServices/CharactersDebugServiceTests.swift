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
        assertIsSuccess(completionResult) {
            XCTAssertEqual($0.code, JsonDataLoaderStub.codeStub)
        }
    }
}

private extension CharactersDebugServiceTests {
    func givenSutWithDataLoader() {
        sut = CharactersDebugService(dataLoader: JsonDataLoaderStub())
    }

    func givenSutWithEmptyDataLoader() {
        sut = CharactersDebugService(dataLoader: JsonDataLoaderEmptyStub())
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
