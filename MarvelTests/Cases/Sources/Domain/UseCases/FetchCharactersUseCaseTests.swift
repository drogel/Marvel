//
//  FetchCharactersUserCaseTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

@testable import Marvel_Debug
import XCTest

class FetchCharactersUseCaseTests: XCTestCase {
    private var sut: FetchCharactersServiceUseCase!
    private var query: FetchCharactersQuery!
    private var serviceMock: CharactersServiceMock!

    override func setUp() {
        super.setUp()
        serviceMock = CharactersServiceMock()
        query = FetchCharactersQuery(offset: 0)
        givenSut(with: serviceMock)
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

    func test_givenSuccessfulService_whenFetching_completesWithPageData() {
        givenSutWithSuccessfulServiceStub(stubbingContentPage: ContentPage<Character>.empty)
        let completionResult = whenRetrievingResultFromFetchingCharacters()
        assertIsSuccess(completionResult) {
            XCTAssertEqual($0, ContentPage<Character>.empty)
        }
    }
}

private class CharactersServiceMock: CharactersService {
    static let cancellableStub = CancellableStub()
    var charactersCallCount = 0

    func characters(from _: Int, completion _: @escaping (CharactersServiceResult) -> Void) -> Cancellable? {
        charactersCallCount += 1
        return Self.cancellableStub
    }
}

private class CharactersServiceFailureStub: CharactersService {
    func characters(from _: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Cancellable? {
        completion(.failure(.emptyData))
        return CancellableStub()
    }
}

private class CharactersServiceSuccessStub: CharactersService {
    private let contentPage: ContentPage<Character>

    init(contentPageStub: ContentPage<Character>) {
        contentPage = contentPageStub
    }

    func characters(from _: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Cancellable? {
        completion(.success(contentPage))
        return CancellableStub()
    }
}

private extension FetchCharactersUseCaseTests {
    func whenRetrievingCancellableFromFetchCharacters(
        completion: ((FetchCharactersResult) -> Void)? = nil
    ) throws -> CancellableStub {
        let cancellable = sut.fetch(query: query) { result in
            completion?(result)
        }
        return try XCTUnwrap(cancellable as? CancellableStub)
    }

    func whenFetchingCharacters(completion: ((FetchCharactersResult) -> Void)? = nil) {
        _ = try? whenRetrievingCancellableFromFetchCharacters(completion: completion)
    }

    func givenSutWithFailureServiceStub() {
        let service = CharactersServiceFailureStub()
        givenSut(with: service)
    }

    func givenSutWithSuccessfulServiceStub(stubbingContentPage contentPage: ContentPage<Character>) {
        let service = CharactersServiceSuccessStub(contentPageStub: contentPage)
        givenSut(with: service)
    }

    func givenSut(with service: CharactersService) {
        sut = FetchCharactersServiceUseCase(service: service)
    }

    func whenRetrievingResultFromFetchingCharacters() -> FetchCharactersResult {
        var completionResult: FetchCharactersResult!
        whenFetchingCharacters { result in
            completionResult = result
        }
        return completionResult
    }
}
