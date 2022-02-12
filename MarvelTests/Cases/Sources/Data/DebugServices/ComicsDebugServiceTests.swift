//
//  ComicsDebugServiceTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 4/2/22.
//

@testable import Marvel_Debug
import XCTest

class ComicsDebugServiceTests: XCTestCase {
    private var sut: ComicsDebugService!
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

    func test_conformsToComicsService() {
        XCTAssertTrue((sut as AnyObject) is ComicsService)
    }

    func test_whenRetrievingComics_returnsNil() {
        XCTAssertNil(sut.comics(for: 1234, from: 1234, completion: { _ in }))
    }

    func test_givenSutWithEmptyDataLoader_whenRetrievingComics_completesWithFailure() {
        givenSutWithEmptyDataLoader()
        let completionResult = whenRetrievingResult()
        assertIsFailure(completionResult)
    }

    func test_givenSutDataLoader_whenRetrievingComics_completesWithSuccess() {
        givenSutWithDataLoader()
        let completionResult = whenRetrievingResult()
        assertIsSuccess(completionResult) {
            XCTAssertEqual($0.code, jsonDataLoaderCode)
        }
    }
}

private extension ComicsDebugServiceTests {
    func givenSutWithDataLoader() {
        let jsonDataLoader = JsonDataLoaderStub<ComicData>()
        jsonDataLoaderCode = jsonDataLoader.codeStub
        sut = ComicsDebugService(dataLoader: jsonDataLoader)
    }

    func givenSutWithEmptyDataLoader() {
        sut = ComicsDebugService(dataLoader: JsonDataLoaderEmptyStub())
    }

    func whenRetrievingResult() -> ComicsServiceResult {
        var completionResult: ComicsServiceResult!
        let expectation = expectation(description: "JSON file parsing completion")
        _ = sut.comics(for: 0, from: 0) { result in
            completionResult = result
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        return completionResult
    }
}
