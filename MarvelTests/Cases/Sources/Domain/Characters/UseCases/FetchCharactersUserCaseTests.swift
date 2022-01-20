//
//  FetchCharactersUserCaseTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import XCTest
@testable import Marvel_Debug

class FetchCharactersUserCaseTests: XCTestCase {

    private var sut: FetchCharactersServiceUseCase!
    private var query: FetchCharactersQuery!
    private var serviceMock: CharactersServiceMock!

    override func setUp() {
        super.setUp()
        serviceMock = CharactersServiceMock()
        query = FetchCharactersQuery(offset: 0)
        sut = FetchCharactersServiceUseCase(service: serviceMock)
    }

    override func tearDown() {
        serviceMock = nil
        query = nil
        sut = nil
        super.tearDown()
    }

    func test_whenFetching_returnsServiceCancellable() throws {
        let cancellable = try whenRetrievingCancellableFromFetchCharacters()
        XCTAssertTrue(CharactersServiceMock.cancellableStub === cancellable)
    }

    func test_whenFetching_callsServiceFetch() throws {
        whenFetchingCharacters()
        XCTAssertEqual(serviceMock.charactersCallCount, 1)
    }

    func test_givenFailingService_whenFetching_completesWithFailure() {
        givenSutWithFailureServiceStub()
        let completionResult = whenRetrievingResultFromFetchingCharacters()
        assertIsFailure(completionResult)
    }

    func test_givenSuccessfulService_whenFetching_completesWithPageInfo() {
        givenSutWithSuccessfulServiceStub(stubbingDataWrapper: DataWrapper.empty)
        let completionResult = whenRetrievingResultFromFetchingCharacters()
        assertIsSuccess(completionResult) {
            XCTAssertEqual($0, PageInfo.empty)
        }
    }

    func test_givenSuccessfulServiceWithNoData_whenFetching_completesWithFailure() {
        givenSutWithSuccessfulServiceStub(stubbingDataWrapper: DataWrapper.withNilData)
        let completionResult = whenRetrievingResultFromFetchingCharacters()
        assertIsFailure(completionResult)
    }
}

private class CancellableStub: Cancellable {

    func cancel() { }
}

private class CharactersServiceMock: CharactersService {

    static let cancellableStub = CancellableStub()
    var charactersCallCount = 0

    func characters(from offset: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Cancellable? {
        charactersCallCount += 1
        return Self.cancellableStub
    }
}

private class CharactersServiceFailureStub: CharactersService {

    func characters(from offset: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Cancellable? {
        completion(.failure(.emptyData))
        return CancellableStub()
    }
}

private class CharactersServiceSuccessStub: CharactersService {

    private let dataWrapperStub: DataWrapper

    init(dataWrapperStub: DataWrapper) {
        self.dataWrapperStub = dataWrapperStub
    }

    func characters(from offset: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Cancellable? {
        completion(.success(dataWrapperStub))
        return CancellableStub()
    }
}

private extension FetchCharactersUserCaseTests {

    func whenRetrievingCancellableFromFetchCharacters(completion: ((Result<PageInfo, Error>) -> Void)? = nil) throws -> CancellableStub {
        let cancellable = sut.fetch(query: query) { result in
            completion?(result)
        }
        return try XCTUnwrap(cancellable as? CancellableStub)
    }

    func whenFetchingCharacters(completion: ((Result<PageInfo, Error>) -> Void)? = nil) {
        let _ = try? whenRetrievingCancellableFromFetchCharacters(completion: completion)
    }

    func givenSutWithFailureServiceStub() {
        sut = FetchCharactersServiceUseCase(service: CharactersServiceFailureStub())
    }

    func givenSutWithSuccessfulServiceStub(stubbingDataWrapper: DataWrapper) {
        let service = CharactersServiceSuccessStub(dataWrapperStub: stubbingDataWrapper)
        sut = FetchCharactersServiceUseCase(service: service)
    }

    func whenRetrievingResultFromFetchingCharacters() -> Result<PageInfo, Error> {
        var completionResult: Result<PageInfo, Error>!
        whenFetchingCharacters { result in
            completionResult = result
        }
        return completionResult
    }
}
