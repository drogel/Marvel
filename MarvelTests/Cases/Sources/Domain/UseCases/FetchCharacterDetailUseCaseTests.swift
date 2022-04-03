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

    func test_whenFetching_callsServiceFetch() async throws {
        try await whenFetchingCharacterIgnoringResult()
        XCTAssertEqual(serviceMock.characterCallCount, 1)
    }

    func test_givenFailingService_whenFetching_completesWithFailure() async throws {
        givenSutWithFailureServiceStub()
        await assertThrows {
            try await whenFetchingCharacterIgnoringResult()
        }
    }

    func test_givenSuccessfulService_whenFetching_completesWithPageData() async throws {
        givenSutWithSuccessfulServiceStub(stubbingPage: ContentPage<Character>.empty)
        try await whenFetchingCharacterIgnoringResult()
    }
}

private class CharacterDetailServiceMock: CharacterDetailService {
    static let disposableStub = DisposableStub()
    var characterCallCount = 0

    func character(with _: Int) async throws -> ContentPage<Character> {
        characterCallCount += 1
        return ContentPage<Character>.empty
    }
}

private class CharacterDetailServiceFailureStub: CharacterDetailService {
    func character(with _: Int) async throws -> ContentPage<Character> {
        throw CharacterDetailServiceError.emptyData
    }
}

private class CharacterDetailServiceSuccessStub: CharacterDetailService {
    private let pageStub: ContentPage<Character>

    init(pageStub: ContentPage<Character>) {
        self.pageStub = pageStub
    }

    func character(with _: Int) async throws -> ContentPage<Character> {
        pageStub
    }
}

private extension FetchCharacterDetailUseCaseTests {
    func whenFetchingCharacterIgnoringResult() async throws {
        _ = try await whenRetrievingResultFromFetchingCharacter()
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

    func whenRetrievingResultFromFetchingCharacter() async throws -> ContentPage<Character> {
        try await sut.fetch(query: query)
    }
}
