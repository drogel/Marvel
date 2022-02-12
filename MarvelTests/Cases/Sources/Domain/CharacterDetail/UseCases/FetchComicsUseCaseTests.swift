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
        sut = FetchComicsServiceUseCase(service: serviceMock)
    }

    override func tearDown() {
        serviceMock = nil
        query = nil
        sut = nil
        super.tearDown()
    }

    func test_whenFetching_returnsServiceCancellable() throws {
        let cancellable = try whenRetrievingCancellableFromFetchCharacter()
        XCTAssertTrue(ComicsServiceMock.cancellableStub === cancellable)
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

    func test_givenSuccessfulService_whenFetching_completesWithPageInfo() {
        givenSutWithSuccessfulServiceStub(stubbingDataWrapper: DataWrapper<ComicData>.empty)
        let completionResult = whenRetrievingResultFromFetchingCharacter()
        assertIsSuccess(completionResult) {
            XCTAssertEqual($0, PageInfo<ComicData>.empty)
        }
    }

    func test_givenSuccessfulServiceWithNoData_whenFetching_completesWithFailure() {
        givenSutWithSuccessfulServiceStub(stubbingDataWrapper: DataWrapper<ComicData>.withNilData)
        let completionResult = whenRetrievingResultFromFetchingCharacter()
        assertIsFailure(completionResult)
    }
}

private class ComicsServiceMock: ComicsService {
    static let cancellableStub = CancellableStub()
    var comicsCallCount = 0

    func comics(
        for _: Int,
        from _: Int,
        completion _: @escaping (ComicsServiceResult) -> Void
    ) -> Cancellable? {
        comicsCallCount += 1
        return Self.cancellableStub
    }
}

private class ComicsServiceFailureStub: ComicsService {
    func comics(
        for _: Int,
        from _: Int,
        completion: @escaping (ComicsServiceResult) -> Void
    ) -> Cancellable? {
        completion(.failure(.emptyData))
        return CancellableStub()
    }
}

private class ComicsServiceSuccessStub: ComicsService {
    private let dataWrapperStub: DataWrapper<ComicData>

    init(dataWrapperStub: DataWrapper<ComicData>) {
        self.dataWrapperStub = dataWrapperStub
    }

    func comics(
        for _: Int,
        from _: Int,
        completion: @escaping (ComicsServiceResult) -> Void
    ) -> Cancellable? {
        completion(.success(dataWrapperStub))
        return CancellableStub()
    }
}

private extension FetchComicsUseCaseTests {
    func whenRetrievingCancellableFromFetchCharacter(
        completion: ((FetchComicsResult) -> Void)? = nil
    ) throws -> CancellableStub {
        let cancellable = sut.fetch(query: query) { result in
            completion?(result)
        }
        return try XCTUnwrap(cancellable as? CancellableStub)
    }

    func whenFetchingCharacter(completion: ((FetchComicsResult) -> Void)? = nil) {
        _ = try? whenRetrievingCancellableFromFetchCharacter(completion: completion)
    }

    func givenSutWithFailureServiceStub() {
        sut = FetchComicsServiceUseCase(service: ComicsServiceFailureStub())
    }

    func givenSutWithSuccessfulServiceStub(stubbingDataWrapper: DataWrapper<ComicData>) {
        let service = ComicsServiceSuccessStub(dataWrapperStub: stubbingDataWrapper)
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
