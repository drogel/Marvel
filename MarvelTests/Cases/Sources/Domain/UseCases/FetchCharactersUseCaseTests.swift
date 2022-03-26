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

    func test_whenFetching_returnsServiceDisposable() throws {
        let disposable = try whenRetrievingDisposableFromFetchCharacters()
        XCTAssertTrue(CharactersServiceMock.disposableStub === disposable)
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
    static let disposableStub = DisposableStub()
    var charactersCallCount = 0

    func characters(from _: Int, completion _: @escaping (CharactersServiceResult) -> Void) -> Disposable? {
        charactersCallCount += 1
        return Self.disposableStub
    }

    func characters(from _: Int) async throws -> ContentPage<Character> {
        charactersCallCount += 1
        return ContentPage<Character>.empty
    }
}

private class CharactersServiceFailureStub: CharactersService {
    func characters(from _: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Disposable? {
        completion(.failure(.emptyData))
        return DisposableStub()
    }

    func characters(from _: Int) async throws -> ContentPage<Character> {
        throw CharactersServiceError.emptyData
    }
}

private class CharactersServiceSuccessStub: CharactersService {
    private let contentPage: ContentPage<Character>

    init(contentPageStub: ContentPage<Character>) {
        contentPage = contentPageStub
    }

    func characters(from _: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Disposable? {
        completion(.success(contentPage))
        return DisposableStub()
    }

    func characters(from _: Int) async throws -> ContentPage<Character> {
        contentPage
    }
}

private extension FetchCharactersUseCaseTests {
    func whenRetrievingDisposableFromFetchCharacters(
        completion: ((FetchCharactersResult) -> Void)? = nil
    ) throws -> DisposableStub {
        let disposable = sut.fetch(query: query) { result in
            completion?(result)
        }
        return try XCTUnwrap(disposable as? DisposableStub)
    }

    func whenFetchingCharacters(completion: ((FetchCharactersResult) -> Void)? = nil) {
        _ = try? whenRetrievingDisposableFromFetchCharacters(completion: completion)
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
