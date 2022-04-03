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

    func test_givenSutWithEmptyDataLoader_whenRetrievingComics_completesWithFailure() async throws {
        givenSutWithEmptyDataLoader()
        await assertThrows {
            try await whenRetrievingResultIgnoringResult()
        }
    }

    func test_givenSutDataLoader_whenRetrievingComics_completesWithSuccess() async throws {
        givenSutWithDataLoader()
        try await whenRetrievingResultIgnoringResult()
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

    func whenRetrievingResultIgnoringResult() async throws {
        _ = try await sut.comics(for: 0, from: 0)
    }
}
