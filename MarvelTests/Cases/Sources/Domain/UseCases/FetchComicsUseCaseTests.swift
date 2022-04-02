//
//  FetchComicsUseCaseTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 4/2/22.
//

@testable import Marvel_Debug
import XCTest

class FetchComicsUseCaseTests: XCTestCase {
    private var sut: FetchComicsServiceUseCase!
    private var query: FetchComicsQuery!
    private var serviceMock: ComicsServiceMock!

    override func setUp() {
        super.setUp()
        serviceMock = ComicsServiceMock()
        query = FetchComicsQuery(characterID: 123_456, offset: 0)
        givenSut(with: serviceMock)
    }

    override func tearDown() {
        serviceMock = nil
        query = nil
        sut = nil
        super.tearDown()
    }

    func test_whenFetching_callsServiceFetch() async {
        await whenFetchingComicsIgnoringResult()
        XCTAssertEqual(serviceMock.comicsCallCount, 1)
    }

    func test_givenFailingService_whenFetching_completesWithFailure() async {
        givenSutWithFailureServiceStub()
        let completionResult = await whenRetrievingResultFromFetchingComics()
        assertIsFailure(completionResult)
    }

    func test_givenSuccessfulService_whenFetching_completesWithPageData() async {
        givenSutWithSuccessfulServiceStub(stubbingPage: ContentPage<Comic>.empty)
        let completionResult = await whenRetrievingResultFromFetchingComics()
        assertIsSuccess(completionResult) {
            XCTAssertEqual($0, ContentPage<Comic>.empty)
        }
    }
}

private class ComicsServiceMock: ComicsService {
    static let disposableStub = DisposableStub()
    var comicsCallCount = 0

    func comics(for _: Int, from _: Int) async throws -> ContentPage<Comic> {
        comicsCallCount += 1
        return ContentPage<Comic>.empty
    }
}

private class ComicsServiceFailureStub: ComicsService {
    func comics(for _: Int, from _: Int) async throws -> ContentPage<Comic> {
        throw ComicsServiceError.emptyData
    }
}

private class ComicsServiceSuccessStub: ComicsService {
    private let pageStub: ContentPage<Comic>

    init(pageStub: ContentPage<Comic>) {
        self.pageStub = pageStub
    }

    func comics(for _: Int, from _: Int) async throws -> ContentPage<Comic> {
        pageStub
    }
}

private extension FetchComicsUseCaseTests {
    func whenFetchingComicsIgnoringResult() async {
        await whenFetchingComics(completion: { _ in })
    }

    func whenFetchingComics(completion: @escaping (FetchComicsResult) -> Void) async {
        await sut.fetch(query: query, completion: completion)
    }

    func givenSutWithFailureServiceStub() {
        let service = ComicsServiceFailureStub()
        givenSut(with: service)
    }

    func givenSutWithSuccessfulServiceStub(stubbingPage: ContentPage<Comic>) {
        let service = ComicsServiceSuccessStub(pageStub: stubbingPage)
        givenSut(with: service)
    }

    func givenSut(with service: ComicsService) {
        sut = FetchComicsServiceUseCase(service: service)
    }

    func whenRetrievingResultFromFetchingComics() async -> FetchComicsResult {
        var completionResult: FetchComicsResult!
        await whenFetchingComics { result in
            completionResult = result
        }
        return completionResult
    }
}
