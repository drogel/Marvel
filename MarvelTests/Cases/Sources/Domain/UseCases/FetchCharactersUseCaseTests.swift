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

    func test_whenFetching_callsServiceFetch() async throws {
        try await whenFetchingCharactersIgnoringResult()
        XCTAssertEqual(serviceMock.charactersCallCount, 1)
    }

    func test_givenFailingService_whenFetching_throwsError() async throws {
        givenSutWithFailureServiceStub()
        do {
            try await whenFetchingCharactersIgnoringResult()
            XCTFail("Expected an error.")
        } catch {}
    }

    func test_givenSuccessfulService_whenFetching_returnsPageData() async throws {
        givenSutWithSuccessfulServiceStub(stubbingContentPage: ContentPage<Character>.empty)
        // TODO: Wrap this kind of do catch because they are duplicated across the test cases
        do {
            let contentPage = try await whenFetchingCharacters()
            XCTAssertEqual(contentPage, ContentPage<Character>.empty)
        } catch {
            XCTFail("Did not expect an error.")
        }
    }
}

private class CharactersServiceMock: CharactersService {
    static let disposableStub = DisposableStub()
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
