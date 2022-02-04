//
//  CharacterDetailDebugServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
@testable import Marvel_Debug
import XCTest

class CharacterDetailDebugServiceTests: XCTestCase {
    private var sut: CharacterDetailDebugService!
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

    func test_conformsToCharacterDetailService() {
        XCTAssertTrue((sut as AnyObject) is CharacterDetailService)
    }

    func test_whenRetrievingCharacterDetail_returnsNil() {
        XCTAssertNil(sut.character(with: 123_456, completion: { _ in }))
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
            XCTAssertEqual($0.code, jsonDataLoaderCode)
        }
    }
}

private extension CharacterDetailDebugServiceTests {
    func givenSutWithDataLoader() {
        let jsonDataLoader = JsonDataLoaderStub<CharacterData>()
        jsonDataLoaderCode = jsonDataLoader.codeStub
        sut = CharacterDetailDebugService(dataLoader: jsonDataLoader)
    }

    func givenSutWithEmptyDataLoader() {
        sut = CharacterDetailDebugService(dataLoader: JsonDataLoaderEmptyStub())
    }

    func whenRetrievingResultFromCharacterDetail() -> CharacterDetailServiceResult {
        var completionResult: CharacterDetailServiceResult!
        let expectation = expectation(description: "JSON file parsing completion")
        _ = sut.character(with: 123_456) { result in
            completionResult = result
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        return completionResult
    }
}
