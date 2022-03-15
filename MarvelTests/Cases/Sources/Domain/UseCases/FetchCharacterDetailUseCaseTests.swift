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
        givenSut(with: serviceMock)
    }

    override func tearDown() {
        serviceMock = nil
        query = nil
        sut = nil
        super.tearDown()
    }

    func test_whenFetching_returnsServiceDisposable() throws {
        let disposable = try whenRetrievingDisposibleFromFetchCharacter()
        XCTAssertTrue(CharacterDetailServiceMock.disposableStub === disposable)
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

    func test_givenSuccessfulService_whenFetching_completesWithPageData() {
        givenSutWithSuccessfulServiceStub(stubbingPage: ContentPage<Character>.empty)
        let completionResult = whenRetrievingResultFromFetchingCharacter()
        assertIsSuccess(completionResult) {
            XCTAssertEqual($0, ContentPage<Character>.empty)
        }
    }
}

private class CharacterDetailServiceMock: CharacterDetailService {
    static let disposableStub = DisposableStub()
    var characterCallCount = 0

    func character(with _: Int, completion _: @escaping (CharacterDetailServiceResult) -> Void) -> Disposable? {
        characterCallCount += 1
        return Self.disposableStub
    }
}

private class CharacterDetailServiceFailureStub: CharacterDetailService {
    func character(with _: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Disposable? {
        completion(.failure(.emptyData))
        return DisposableStub()
    }
}

private class CharacterDetailServiceSuccessStub: CharacterDetailService {
    private let pageStub: ContentPage<Character>

    init(pageStub: ContentPage<Character>) {
        self.pageStub = pageStub
    }

    func character(with _: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Disposable? {
        completion(.success(pageStub))
        return DisposableStub()
    }
}

private extension FetchCharacterDetailUseCaseTests {
    func whenRetrievingDisposibleFromFetchCharacter(
        completion: ((FetchCharacterDetailResult) -> Void)? = nil
    ) throws -> DisposableStub {
        let disposable = sut.fetch(query: query) { result in
            completion?(result)
        }
        return try XCTUnwrap(disposable as? DisposableStub)
    }

    func whenFetchingCharacter(completion: ((FetchCharacterDetailResult) -> Void)? = nil) {
        _ = try? whenRetrievingDisposibleFromFetchCharacter(completion: completion)
    }

    func givenSutWithFailureServiceStub() {
        let service = CharacterDetailServiceFailureStub()
        givenSut(with: service)
    }

    func givenSutWithSuccessfulServiceStub(stubbingPage: ContentPage<Character>) {
        let service = CharacterDetailServiceSuccessStub(pageStub: stubbingPage)
        givenSut(with: service)
    }

    func givenSut(with service: CharacterDetailService) {
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
