//
//  FetchCharacterDetailUseCaseTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

@testable import Marvel_Debug
import XCTest

class FetchCharacterDetailUseCaseTests: XCTestCase {
    private var sut: FetchCharacterDetailServiceUseCase!
    private var query: FetchCharacterDetailQuery!
    private var serviceMock: CharacterDetailServiceMock!

    override func setUp() {
        super.setUp()
        serviceMock = CharacterDetailServiceMock()
        query = FetchCharacterDetailQuery(characterID: 123_456)
        sut = FetchCharacterDetailServiceUseCase(service: serviceMock)
    }

    override func tearDown() {
        serviceMock = nil
        query = nil
        sut = nil
        super.tearDown()
    }

    func test_whenFetching_returnsServiceCancellable() throws {
        let cancellable = try whenRetrievingCancellableFromFetchCharacter()
        XCTAssertTrue(CharacterDetailServiceMock.cancellableStub === cancellable)
    }

    func test_whenFetching_callsServiceFetch() throws {
        whenFetchingCharacter()
        XCTAssertEqual(serviceMock.characterCallCount, 1)
    }

    func test_givenFailingService_whenFetching_completesWithFailure() {
        givenSutWithFailureServiceStub()
        let completionResult = whenRetrievingResultFromFetchingCharacter()
        assertIsFailure(completionResult)
    }

    func test_givenSuccessfulService_whenFetching_completesWithPageInfo() {
        givenSutWithSuccessfulServiceStub(stubbingDataWrapper: DataWrapper.empty)
        let completionResult = whenRetrievingResultFromFetchingCharacter()
        assertIsSuccess(completionResult) {
            XCTAssertEqual($0, PageInfo.empty)
        }
    }

    func test_givenSuccessfulServiceWithNoData_whenFetching_completesWithFailure() {
        givenSutWithSuccessfulServiceStub(stubbingDataWrapper: DataWrapper.withNilData)
        let completionResult = whenRetrievingResultFromFetchingCharacter()
        assertIsFailure(completionResult)
    }
}

private class CharacterDetailServiceMock: CharacterDetailService {
    static let cancellableStub = CancellableStub()
    var characterCallCount = 0

    func character(with _: Int, completion _: @escaping (CharacterDetailServiceResult) -> Void) -> Cancellable? {
        characterCallCount += 1
        return Self.cancellableStub
    }
}

private class CharacterDetailServiceFailureStub: CharacterDetailService {
    func character(with _: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Cancellable? {
        completion(.failure(.emptyData))
        return CancellableStub()
    }
}

private class CharacterDetailServiceSuccessStub: CharacterDetailService {
    private let dataWrapperStub: DataWrapper

    init(dataWrapperStub: DataWrapper) {
        self.dataWrapperStub = dataWrapperStub
    }

    func character(with _: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Cancellable? {
        completion(.success(dataWrapperStub))
        return CancellableStub()
    }
}

private extension FetchCharacterDetailUseCaseTests {
    func whenRetrievingCancellableFromFetchCharacter(
        completion: ((FetchCharacterDetailResult) -> Void)? = nil
    ) throws -> CancellableStub {
        let cancellable = sut.fetch(query: query) { result in
            completion?(result)
        }
        return try XCTUnwrap(cancellable as? CancellableStub)
    }

    func whenFetchingCharacter(completion: ((FetchCharacterDetailResult) -> Void)? = nil) {
        _ = try? whenRetrievingCancellableFromFetchCharacter(completion: completion)
    }

    func givenSutWithFailureServiceStub() {
        sut = FetchCharacterDetailServiceUseCase(service: CharacterDetailServiceFailureStub())
    }

    func givenSutWithSuccessfulServiceStub(stubbingDataWrapper: DataWrapper) {
        let service = CharacterDetailServiceSuccessStub(dataWrapperStub: stubbingDataWrapper)
        sut = FetchCharacterDetailServiceUseCase(service: service)
    }

    func whenRetrievingResultFromFetchingCharacter() -> FetchCharacterDetailResult {
        var completionResult: FetchCharacterDetailResult!
        whenFetchingCharacter { result in
            completionResult = result
        }
        return completionResult
    }
}
