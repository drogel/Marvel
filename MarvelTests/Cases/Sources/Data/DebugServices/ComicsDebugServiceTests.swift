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

    override func setUp() {
        super.setUp()
        givenSutWithEmptyDataLoader()
    }

    override func tearDown() {
        sut = nil
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
        assertIsSuccess(completionResult)
    }
}

private extension ComicsDebugServiceTests {
    func givenSutWithDataLoader() {
        let jsonDataLoader = JsonDataLoaderStub<ComicData>()
        givenSut(with: jsonDataLoader)
    }

    func givenSutWithEmptyDataLoader() {
        givenSut(with: JsonDataLoaderEmptyStub())
    }

    func givenSut(with dataLoader: JsonDataLoader) {
        sut = ComicsDebugService(
            dataLoader: dataLoader,
            dataResultHandler: ComicDataResultHandlerFactory.createWithDataMappers()
        )
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
