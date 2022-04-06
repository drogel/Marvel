//
//  CharacterInfoViewModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

import Combine
@testable import Marvel_Debug
import XCTest
import Domain
import DomainTestUtils

class CharacterInfoViewModelTests: XCTestCase {
    private var sut: CharacterInfoViewModel!
    private var characterFetcherMock: CharacterFetcherMock!
    private var characterIDStub: Int!
    private var imageURLBuilderMock: ImageURLBuilderMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        characterFetcherMock = CharacterFetcherMock()
        cancellables = Set<AnyCancellable>()
        characterIDStub = 123_456
        imageURLBuilderMock = ImageURLBuilderMock()
        givenSut(with: characterFetcherMock)
    }

    override func tearDown() {
        cancellables = nil
        characterIDStub = nil
        characterFetcherMock = nil
        imageURLBuilderMock = nil
        sut = nil
        super.tearDown()
    }

    func test_conformsToViewModel() {
        XCTAssertTrue((sut as AnyObject) is ViewModel)
    }

    func test_givenDidNotStartYet_emitsIdleState() {
        let idleStateReceivedExpectation = expectation(description: "Received idle state")
        sut.loadingStatePublisher
            .assertOutput(matches: .idle, expectation: idleStateReceivedExpectation)
            .store(in: &cancellables)
        wait(for: [idleStateReceivedExpectation], timeout: 0.1)
    }

    func test_infoModelIsNilInitially() {
        assertInfoModelIsNil()
    }

    func test_givenCharacterFetcher_whenStrating_fetchesCharacter() async {
        await sut.start()
        XCTAssertEqual(characterFetcherMock.fetchCallCount, 1)
    }

    func test_givenCharacterFetcher_whenStrating_fetchesCharacterWithProvidedID() async {
        await sut.start()
        XCTAssertEqual(characterFetcherMock.fetchCallCount(withID: characterIDStub), 1)
    }

    func test_givenDidNotStartYet_receivesEmptyInfoModel() {
        let receivedResultExpectation = expectation(description: "Received a nil result")
        let expectedState = CharacterInfoViewModelState.success(nil)
        sut.infoStatePublisher
            .assertOutput(matches: expectedState, expectation: receivedResultExpectation)
            .store(in: &cancellables)
        wait(for: [receivedResultExpectation], timeout: 0.1)
    }

    func test_givenSuccessfulCharacterFetcher_whenStarting_receivesExpectedInfoModel() async {
        givenSutWithSuccessfulFetcher()
        let receivedResultExpectation = expectation(description: "Received a result")
        let expectedInfoModel = buildExpectedInfoModel(from: CharacterFetcherSuccessfulStub.resultsStub)
        let expectedState = CharacterInfoViewModelState.success(expectedInfoModel)
        sut.infoStatePublisher
            .dropFirst()
            .assertOutput(matches: expectedState, expectation: receivedResultExpectation)
            .store(in: &cancellables)
        await sut.start()
        wait(for: [receivedResultExpectation], timeout: 0.1)
    }

    func test_givenSucessfulFetcher_whenStartingFinished_emitsLoadedState() async {
        givenSutWithSuccessfulFetcher()
        let loadedStateReceivedExpectation = expectation(description: "Received loaded state")
        let expectedStates: [LoadingState] = [.idle, .loading, .loaded]
        sut.loadingStatePublisher
            .assertOutput(matches: expectedStates, expectation: loadedStateReceivedExpectation)
            .store(in: &cancellables)
        await sut.start()
        wait(for: [loadedStateReceivedExpectation], timeout: 0.1)
    }

    func test_givenSutWithFailingFetcher_whenStarting_emitsFailureState() async {
        givenSutWithFailingFetcher()
        let receivedResultExpectation = expectation(description: "Received a result")
        let expectedState = CharacterInfoViewModelState.failure(.noAuthorization)
        sut.infoStatePublisher
            .dropFirst()
            .assertOutput(matches: expectedState, expectation: receivedResultExpectation)
            .store(in: &cancellables)
        await sut.start()
        wait(for: [receivedResultExpectation], timeout: 0.1)
    }

    func test_givenDidStartSuccessfully_whenRetrievingCharacterImage_imageURLBuiltExpectedVariant() async {
        await givenStartCompletedSuccessfully()
        XCTAssertNil(imageURLBuilderMock.mostRecentImageVariant)
    }
}

private class CharacterFetcherMock: FetchCharacterDetailUseCase {
    var fetchCallCount = 0
    var fetchCallCountsForID: [Int: Int] = [:]

    func fetch(query: FetchCharacterDetailQuery) async throws -> ContentPage<Character> {
        fetchCallCount += 1
        fetchCallCountsForID[query.characterID] = fetchCallCountsForID[query.characterID] ?? 0 + 1
        return ContentPage<Character>.empty
    }

    func fetchCallCount(withID identifier: Int) -> Int {
        guard let fetchCallCountForID = fetchCallCountsForID[identifier] else { return 0 }
        return fetchCallCountForID
    }
}

private class CharacterFetcherSuccessfulStub: CharacterFetcherMock {
    static let resultsStub = [Character.aginar]
    static let pageDataStub = ContentPage<Character>.zeroWith(contents: resultsStub)

    override func fetch(query: FetchCharacterDetailQuery) async throws -> ContentPage<Character> {
        _ = try await super.fetch(query: query)
        return Self.pageDataStub
    }
}

private class CharacterFetcherFailingStub: CharacterFetcherMock {
    override func fetch(query _: FetchCharacterDetailQuery) async throws -> ContentPage<Character> {
        throw FetchCharacterDetailUseCaseError.unauthorized
    }
}

private extension CharacterInfoViewModelTests {
    func givenSutWithSuccessfulFetcher() {
        characterFetcherMock = CharacterFetcherSuccessfulStub()
        givenSut(with: characterFetcherMock)
    }

    func givenSut(with characterFetcherMock: CharacterFetcherMock) {
        sut = CharacterInfoViewModel(
            characterFetcher: characterFetcherMock,
            characterID: characterIDStub,
            imageURLBuilder: imageURLBuilderMock
        )
    }

    func givenSutWithFailingFetcher() {
        characterFetcherMock = CharacterFetcherFailingStub()
        givenSut(with: characterFetcherMock)
    }

    func givenStartCompletedSuccessfully() async {
        givenSutWithSuccessfulFetcher()
        await sut.start()
    }

    func assertInfoModelIsNil(line: UInt = #line) {
        let receivedValueExpectation = expectation(description: "Received a value")
        sut.infoStatePublisher
            .assertReceivedValueNotNil(expectation: receivedValueExpectation, line: line)
            .store(in: &cancellables)
        wait(for: [receivedValueExpectation], timeout: 0.1)
    }

    func buildExpectedInfoModel(from characters: [Character]) -> CharacterInfoModel {
        let character = characters.first!
        let characterInfoData = CharacterDescriptionModel(name: character.name, description: character.description)
        let characterImageModel = CharacterImageModel(imageURL: imageURLBuilderMock.buildURL(from: character.image))
        return CharacterInfoModel(image: characterImageModel, description: characterInfoData)
    }
}
