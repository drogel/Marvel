//
//  CharacterDetailDebugServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
import XCTest
@testable import Marvel_Debug

class CharacterDetailDebugServiceTests: XCTestCase {

    private var sut: CharacterDetailDebugService!

    override func setUp() {
        super.setUp()
        givenSutWithEmptyDataLoader()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_conformsToCharacterDetailService() {
        XCTAssertTrue((sut as AnyObject) is CharacterDetailService)
    }

    func test_whenRetrievingCharacterDetail_returnsNil() {
        XCTAssertNil(sut.character(with: 123456, completion: { _ in }))
    }

    func test_givenSutWithEmptyDataLoader_whenRetrievingCharacterDetail_completesWithFailure() {
        givenSutWithEmptyDataLoader()
        let completionResult = whenRetrievingResultFromCharacterDetail()
        assertIsFailure(completionResult)
    }

    func test_givenSutDataLoader_whenRetrievingCharacterDetail_completesWithSuccess() {
        givenSutWithDataLoader()
        let completionResult = whenRetrievingResultFromCharacterDetail()
        assertIsSuccess(completionResult) {
            XCTAssertEqual($0.code, JsonDataLoaderStub.codeStub)
        }
    }
}

private extension CharacterDetailDebugServiceTests {

    func givenSutWithDataLoader() {
        sut = CharacterDetailDebugService(dataLoader: JsonDataLoaderStub())
    }

    func givenSutWithEmptyDataLoader() {
        sut = CharacterDetailDebugService(dataLoader: JsonDataLoaderEmptyStub())
    }

    func whenRetrievingResultFromCharacterDetail() -> CharacterDetailServiceResult {
        var completionResult: CharacterDetailServiceResult!
        let expectation = expectation(description: "JSON file parsing completion")
        let _ = sut.character(with: 123456) { result in
            completionResult = result
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        return completionResult
    }
}
