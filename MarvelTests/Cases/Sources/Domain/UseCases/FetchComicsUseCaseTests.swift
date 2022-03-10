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

    func test_whenFetching_returnsServiceDisposable() throws {
        let disposable = try whenRetrievingDisposableFromFetchCharacter()
        XCTAssertTrue(ComicsServiceMock.disposableStub === disposable)
    }

    func test_whenFetching_callsServiceFetch() throws {
        whenFetchingCharacter()
        XCTAssertEqual(serviceMock.comicsCallCount, 1)
    }

    func test_givenFailingService_whenFetching_completesWithFailure() {
        givenSutWithFailureServiceStub()
        let completionResult = whenRetrievingResultFromFetchingCharacter()
        assertIsFailure(completionResult)
    }

    func test_givenSuccessfulService_whenFetching_completesWithPageData() {
        givenSutWithSuccessfulServiceStub(stubbingPage: ContentPage<Comic>.empty)
        let completionResult = whenRetrievingResultFromFetchingCharacter()
        assertIsSuccess(completionResult) {
            XCTAssertEqual($0, ContentPage<Comic>.empty)
        }
    }
}

private class ComicsServiceMock: ComicsService {
    static let disposableStub = DisposableStub()
    var comicsCallCount = 0

    func comics(
        for _: Int,
        from _: Int,
        completion _: @escaping (ComicsServiceResult) -> Void
    ) -> Disposable? {
        comicsCallCount += 1
        return Self.disposableStub
    }
}

private class ComicsServiceFailureStub: ComicsService {
    func comics(
        for _: Int,
        from _: Int,
        completion: @escaping (ComicsServiceResult) -> Void
    ) -> Disposable? {
        completion(.failure(.emptyData))
        return DisposableStub()
    }
}

private class ComicsServiceSuccessStub: ComicsService {
    private let pageStub: ContentPage<Comic>

    init(pageStub: ContentPage<Comic>) {
        self.pageStub = pageStub
    }

    func comics(for _: Int, from _: Int, completion: @escaping (ComicsServiceResult) -> Void) -> Disposable? {
        completion(.success(pageStub))
        return DisposableStub()
    }
}

private extension FetchComicsUseCaseTests {
    func whenRetrievingDisposableFromFetchCharacter(
        completion: ((FetchComicsResult) -> Void)? = nil
    ) throws -> DisposableStub {
        let disposable = sut.fetch(query: query) { result in
            completion?(result)
        }
        return try XCTUnwrap(disposable as? DisposableStub)
    }

    func whenFetchingCharacter(completion: ((FetchComicsResult) -> Void)? = nil) {
        _ = try? whenRetrievingDisposableFromFetchCharacter(completion: completion)
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

    func whenRetrievingResultFromFetchingCharacter() -> FetchComicsResult {
        var completionResult: FetchComicsResult!
        whenFetchingCharacter { result in
            completionResult = result
        }
        return completionResult
    }
}
