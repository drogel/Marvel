//
//  CharacterInfoPresentationModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

import Combine
@testable import Marvel_Debug
import XCTest

class CharacterInfoPresentationModelTests: XCTestCase {
    private var sut: CharacterInfoPresentationModel!
    private var characterFetcherMock: CharacterFetcherMock!
    private var characterIDStub: Int!
    private var viewDelegateMock: CharacterInfoViewDelegateMock!
    private var imageURLBuilderMock: ImageURLBuilderMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        characterFetcherMock = CharacterFetcherMock()
        cancellables = Set<AnyCancellable>()
        characterIDStub = 123_456
        viewDelegateMock = CharacterInfoViewDelegateMock()
        imageURLBuilderMock = ImageURLBuilderMock()
        givenSut(with: characterFetcherMock)
    }

    override func tearDown() {
        cancellables = nil
        characterIDStub = nil
        characterFetcherMock = nil
        imageURLBuilderMock = nil
        viewDelegateMock = nil
        sut = nil
        super.tearDown()
    }

    func test_conformsToPresentationModel() {
        XCTAssertTrue((sut as AnyObject) is PresentationModel)
    }

    func test_givenViewDelegate_whenStarting_notifiesLoadingToViewDelegate() {
        givenViewDelegate()
        sut.start()
        XCTAssertEqual(viewDelegateMock.didStartLoadingCallCount, 1)
    }

    func test_infoModelIsNilInitially() {
        assertInfoModelIsNil()
    }

    func test_givenCharacterFetcher_whenStrating_fetchesCharacter() {
        sut.start()
        XCTAssertEqual(characterFetcherMock.fetchCallCount, 1)
    }

    func test_givenCharacterFetcher_whenStrating_fetchesCharacterWithProvidedID() {
        sut.start()
        XCTAssertEqual(characterFetcherMock.fetchCallCount(withID: characterIDStub), 1)
    }

    func test_givenSuccessfulCharacterFetcher_whenStartingCompletes_notifiesViewWithData() {
        givenStartCompletedSuccessfully()
        XCTAssertEqual(viewDelegateMock.didRetrieveDataCallCount, 1)
    }

    func test_givenDidNotStartYet_receivesEmptyInfoModel() {
        let receivedResultExpectation = expectation(description: "Received a nil result")
        let expectedState = CharacterInfoViewModelState.success(nil)
        sut.infoStatePublisher
            .assertOutput(matches: expectedState, expectation: receivedResultExpectation)
            .store(in: &cancellables)
        wait(for: [receivedResultExpectation], timeout: 0.1)
    }

    func test_givenSuccessfulCharacterFetcher_whenStarting_receivesExpectedInfoModel() {
        givenSutWithSuccessfulFetcher()
        let receivedResultExpectation = expectation(description: "Received a result")
        let expectedInfoModel = buildExpectedInfoModel(from: CharacterFetcherSuccessfulStub.resultsStub)
        let expectedState = CharacterInfoViewModelState.success(expectedInfoModel)
        sut.infoStatePublisher
            .dropFirst()
            .assertOutput(matches: expectedState, expectation: receivedResultExpectation)
            .store(in: &cancellables)
        sut.start()
        wait(for: [receivedResultExpectation], timeout: 0.1)
    }

    func test_givenStartFailed_receivesNilInfoModel() {
        givenSutWithFailingFetcher()
        assertInfoModelIsNil()
        sut.start()
    }

    func test_givenViewDelegate_whenStartingCompletesSuccessfully_notifiesFinishLoadToViewDelegate() {
        givenStartCompletedSuccessfully()
        XCTAssertEqual(viewDelegateMock.didFinishLoadingCallCount, 1)
    }

    func test_givenDidStartSuccessfully_whenDisposing_cancellsRequests() {
        givenStartCompletedSuccessfully()
        sut.dispose()
        assertCancelledRequests()
    }

    func test_givenStartFailed_notifiesViewDelegate() {
        givenStartFailed()
        XCTAssertEqual(viewDelegateMock.didFailCallCount, 1)
    }

    func test_givenDidStartSuccessfully_whenRetrievingCharacterImage_imageURLBuiltExpectedVariant() {
        givenStartCompletedSuccessfully()
        XCTAssertNil(imageURLBuilderMock.mostRecentImageVariant)
    }
}

private class CharacterInfoViewDelegateMock: CharacterInfoPresentationModelViewDelegate {
    var didStartLoadingCallCount = 0
    var didFinishLoadingCallCount = 0
    var didRetrieveDataCallCount = 0
    var didFailCallCount = 0

    func modelDidStartLoading(_: CharacterInfoPresentationModelProtocol) {
        didStartLoadingCallCount += 1
    }

    func modelDidFinishLoading(_: CharacterInfoPresentationModelProtocol) {
        didFinishLoadingCallCount += 1
    }

    func modelDidRetrieveData(_: CharacterInfoPresentationModelProtocol) {
        didRetrieveDataCallCount += 1
    }

    func model(_: CharacterInfoPresentationModelProtocol, didFailWithError _: String) {
        didFailCallCount += 1
    }
}

private class CharacterFetcherMock: FetchCharacterDetailUseCase {
    var fetchCallCount = 0
    var fetchCallCountsForID: [Int: Int] = [:]
    var disposable: DisposableMock?

    func fetch(
        query: FetchCharacterDetailQuery,
        completion _: @escaping (FetchCharacterDetailResult) -> Void
    ) -> Disposable? {
        fetchCallCount += 1
        fetchCallCountsForID[query.characterID] = fetchCallCountsForID[query.characterID] ?? 0 + 1
        disposable = DisposableMock()
        return disposable
    }

    func fetchCallCount(withID identifier: Int) -> Int {
        guard let fetchCallCountForID = fetchCallCountsForID[identifier] else { return 0 }
        return fetchCallCountForID
    }
}

private class CharacterFetcherSuccessfulStub: CharacterFetcherMock {
    static let resultsStub = [Character.aginar]
    static let pageDataStub = ContentPage<Character>.zeroWith(contents: resultsStub)

    override func fetch(
        query: FetchCharacterDetailQuery,
        completion: @escaping (FetchCharacterDetailResult) -> Void
    ) -> Disposable? {
        let result = super.fetch(query: query, completion: completion)
        completion(.success(Self.pageDataStub))
        return result
    }
}

private class CharacterFetcherFailingStub: CharacterFetcherMock {
    override func fetch(
        query: FetchCharacterDetailQuery,
        completion: @escaping (FetchCharacterDetailResult) -> Void
    ) -> Disposable? {
        let result = super.fetch(query: query, completion: completion)
        completion(.failure(.unauthorized))
        return result
    }
}

private extension CharacterInfoPresentationModelTests {
    func givenViewDelegate() {
        sut.viewDelegate = viewDelegateMock
    }

    func givenSutWithSuccessfulFetcher() {
        characterFetcherMock = CharacterFetcherSuccessfulStub()
        givenSut(with: characterFetcherMock)
    }

    func givenSut(with characterFetcherMock: CharacterFetcherMock) {
        sut = CharacterInfoPresentationModel(
            characterFetcher: characterFetcherMock,
            characterID: characterIDStub,
            imageURLBuilder: imageURLBuilderMock
        )
    }

    func givenSutWithFailingFetcher() {
        characterFetcherMock = CharacterFetcherFailingStub()
        givenSut(with: characterFetcherMock)
    }

    func givenStartCompletedSuccessfully() {
        givenSutWithSuccessfulFetcher()
        givenViewDelegate()
        sut.start()
    }

    func givenStartFailed() {
        givenSutWithFailingFetcher()
        givenViewDelegate()
        sut.start()
    }

    func retrieveFetcherMockDisposableMock() -> DisposableMock {
        try! XCTUnwrap(characterFetcherMock.disposable)
    }

    func assertCancelledRequests(line _: UInt = #line) {
        let disposableMock = retrieveFetcherMockDisposableMock()
        XCTAssertEqual(disposableMock.didDisposeCallCount, 1)
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
