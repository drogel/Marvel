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

    func test_givenSuccessfulService_whenFetching_completesWithPageData() {
        givenSutWithSuccessfulServiceStub(stubbingPage: ContentPage<Character>.empty)
        let completionResult = whenRetrievingResultFromFetchingCharacter()
        assertIsSuccess(completionResult) {
            XCTAssertEqual($0, ContentPage<Character>.empty)
        }
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
    private let pageStub: ContentPage<Character>

    init(pageStub: ContentPage<Character>) {
        self.pageStub = pageStub
    }

    func character(with _: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Cancellable? {
        completion(.success(pageStub))
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
        let service = CharacterDetailServiceFailureStub()
        givenSut(with: service)
    }

    func givenSutWithSuccessfulServiceStub(stubbingPage: ContentPage<Character>) {
        let service = CharacterDetailServiceSuccessStub(pageStub: stubbingPage)
        givenSut(with: service)
    }

    func givenSut(with service: CharacterDetailService) {
        sut = FetchCharacterDetailServiceUseCase(
            service: service,
            characterMapper: CharacterDataMapper(imageMapper: ImageDataMapper()),
            pageMapper: PageDataMapper()
        )
    }

    func whenRetrievingResultFromFetchingCharacter() -> FetchCharacterDetailResult {
        var completionResult: FetchCharacterDetailResult!
        whenFetchingCharacter { result in
            completionResult = result
        }
        return completionResult
    }
}
