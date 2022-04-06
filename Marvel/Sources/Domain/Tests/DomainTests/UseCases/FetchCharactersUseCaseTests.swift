//
//  FetchCharactersUserCaseTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

@testable import Domain
import DomainTestUtils
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

    func test_whenFetching_callsServiceFetch() async throws {
        try await whenFetchingCharactersIgnoringResult()
        XCTAssertEqual(serviceMock.charactersCallCount, 1)
    }

    func test_givenFailingService_whenFetching_throwsError() async throws {
        givenSutWithFailureServiceStub()
        await assertThrows {
            try await whenFetchingCharactersIgnoringResult()
        }
    }

    func test_givenSuccessfulService_whenFetching_returnsPageData() async throws {
        givenSutWithSuccessfulServiceStub(stubbingContentPage: ContentPage<Character>.empty)
        let contentPage = try await whenFetchingCharacters()
        XCTAssertEqual(contentPage, ContentPage<Character>.empty)
    }
}

private class CharactersServiceMock: CharactersService {
    var charactersCallCount = 0

    func characters(from _: Int) async throws -> ContentPage<Character> {
        charactersCallCount += 1
        return ContentPage<Character>.empty
    }
}

private class CharactersServiceFailureStub: CharactersService {
    func characters(from _: Int) async throws -> ContentPage<Character> {
        throw CharactersServiceError.emptyData
    }
}

private class CharactersServiceSuccessStub: CharactersService {
    private let contentPage: ContentPage<Character>

    init(contentPageStub: ContentPage<Character>) {
        contentPage = contentPageStub
    }

    func characters(from _: Int) async throws -> ContentPage<Character> {
        contentPage
    }
}

private extension FetchCharactersUseCaseTests {
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

    func whenFetchingCharacters() async throws -> ContentPage<Character> {
        try await sut.fetch(query: query)
    }

    func whenFetchingCharactersIgnoringResult() async throws {
        _ = try await sut.fetch(query: query)
    }
}
