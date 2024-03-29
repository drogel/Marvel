//
//  CharactersViewModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import Combine
import Domain
import DomainTestUtils
@testable import Presentation_Characters
import Presentation_Common
import TestUtils
import XCTest

class CharactersViewModelTests: XCTestCase {
    private var sut: CharactersViewModel!
    private var coordinatorDelegateMock: CharactersCoordinatorDelegateMock!
    private var charactersFetcherMock: FetchCharactersUseCaseMock!
    private var offsetPagerMock: OffsetPagerPartialMock!
    private var methodCallRecorder: ViewDelegatePagerCallRecorder!
    private var imageURLBuilderMock: ImageURLBuilderMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        coordinatorDelegateMock = CharactersCoordinatorDelegateMock()
        charactersFetcherMock = FetchCharactersUseCaseMock()
        offsetPagerMock = OffsetPagerPartialMock()
        imageURLBuilderMock = ImageURLBuilderMock()
        cancellables = Set<AnyCancellable>()
        givenSut()
    }

    override func tearDown() {
        charactersFetcherMock = nil
        coordinatorDelegateMock = nil
        offsetPagerMock = nil
        imageURLBuilderMock = nil
        methodCallRecorder = nil
        cancellables = nil
        sut = nil
        super.tearDown()
    }

    func test_conformsToViewModel() {
        XCTAssertTrue((sut as AnyObject) is ViewModel)
    }

    func test_conformsToCharactersViewModel() {
        XCTAssertTrue((sut as AnyObject) is CharactersViewModelProtocol)
    }

    func test_givenDidStartSuccessfullyAndACoordinatorDelegate_whenSelecting_notifiesDelegate() async {
        await givenDidStartSuccessfully()
        givenCoordinatorDelegate()
        sut.select(at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(coordinatorDelegateMock.didSelectCallCount, 1)
    }

    func test_givenCharactersFetcher_whenStrating_fetchesCharacters() async {
        await sut.start()
        XCTAssertEqual(charactersFetcherMock.fetchCallCount, 1)
    }

    func test_whenInitialized_notifiesIdle() {
        let receivedIdleExpectation = expectation(description: "Receives idle state")
        sut.loadingStatePublisher
            .assertOutput(matches: .idle, expectation: receivedIdleExpectation)
            .store(in: &cancellables)
        wait(for: [receivedIdleExpectation], timeout: 0.1)
    }

    func test_whenStarting_notifiesLoadingStates() async {
        let receivedLoadingExpectation = expectation(description: "Receives loading state")
        let expectedStates: [LoadingState] = [.idle, .loading, .loaded]
        sut.loadingStatePublisher
            .assertOutput(matches: expectedStates, expectation: receivedLoadingExpectation)
            .store(in: &cancellables)
        await sut.start()
        wait(for: [receivedLoadingExpectation], timeout: 0.1)
    }

    func test_whenStartingCompletesSuccessfully_notifiesFinishedLoading() async {
        givenSutWithSuccessfulFetcher()
        let receivedLoadedExpectation = expectation(description: "Receives loaded state")
        sut.loadingStatePublisher
            .dropFirst(2)
            .assertOutput(matches: .loaded, expectation: receivedLoadedExpectation)
            .store(in: &cancellables)
        await sut.start()
        wait(for: [receivedLoadedExpectation], timeout: 0.1)
    }

    func test_givenDidNotFetchYet_whenRetrievingCellData_publishesEmptyArray() {
        let receivedValueExpectation = expectation(description: "Publishes empty models")
        let expectedEmptyState: CharactersViewModelState = .success([])
        sut.statePublisher
            .assertOutput(matches: expectedEmptyState, expectation: receivedValueExpectation)
            .store(in: &cancellables)
        wait(for: [receivedValueExpectation], timeout: 0.1)
    }

    func test_givenSutWithSuccessfulFetcher_whenStarting_publishesSingleDataAfterDroppingInitial() async throws {
        givenSutWithSuccessfulFetcher()
        let receivedValueExpectation = expectation(description: "Publishes single value")
        let expectedModels = buildExpectedCellModels(from: FetchCharactersUseCaseSuccessfulStub.charactersStub)
        let expectedState: CharactersViewModelState = .success(expectedModels)
        sut.statePublisher
            .dropFirst()
            .assertOutput(matches: expectedState, expectation: receivedValueExpectation)
            .store(in: &cancellables)
        await sut.start()
        wait(for: [receivedValueExpectation], timeout: 0.1)
    }

    func test_whenWillDisplayCellFromIndexZero_doesNotFetch() async {
        await whenWillDisplayCellIgnoringQuery(atIndex: 0)
        XCTAssertNil(charactersFetcherMock.mostRecentQuery)
        XCTAssertEqual(charactersFetcherMock.fetchCallCount, 0)
    }

    func test_givenDidStartSuccessfully_whenWillDisplayCell_fetchesCharactersFromLoadedOffset() async throws {
        await givenDidStartSuccessfully()
        let givenIndex = FetchCharactersUseCaseSuccessfulStub.charactersStub.count - 1
        let mostRecentQuery = try await whenWillDisplayCell(atIndex: givenIndex)
        XCTAssertEqual(mostRecentQuery.offset, FetchCharactersUseCaseSuccessfulStub.charactersStub.count)
    }

    func test_givenStartFailed_whenWillDisplayCell_doesNotFetch() async throws {
        await givenStartFailed()
        let mostRecentQuery = try await whenWillDisplayCell(atIndex: 0)
        XCTAssertEqual(mostRecentQuery.offset, 0)
    }

    func test_whenStartingFinishes_updatesPage() async {
        givenSutWithSuccessfulFetcher()
        assertPagerUpdate(callCount: 0)
        await sut.start()
        assertPagerUpdate(callCount: 1)
    }

    func test_givenDidStartSuccessfully_whenAboutToDisplayACell_checksForMoreContent() async {
        await givenDidStartSuccessfully()
        assertPagerIsAtEndOfCurrentPageWithMoreContent(callCount: 0)
        await whenWillDisplayCellIgnoringQuery(atIndex: 0)
        assertPagerIsAtEndOfCurrentPageWithMoreContent(callCount: 1)
    }

    func test_givenDidStartSuccessfully_whenAboutToDisplayACell_updateNotificationsAreCalledInOrder() async {
        let expectedCalls: [ViewDelegatePagerCallRecorder.Method] = [
            .isAtEndOfCurrentPageWithMoreContent,
            .update,
        ]
        givenSuccessfulCharactersFetcher()
        givenSutWithCallRecorder()
        await whenWillDisplayCellIgnoringQuery(atIndex: 0)
        XCTAssertEqual(methodCallRecorder.methodsCalled, expectedCalls)
    }

    func test_givenDidStartSuccessfully_whenRetrievingCharacters_imageURLBuiltExpectedVariant() async throws {
        await givenDidStartSuccessfully()
        let expectedImageVariant: ImageVariant = .detail
        let actualUsedVariant = try XCTUnwrap(imageURLBuilderMock.mostRecentImageVariant)
        XCTAssertEqual(actualUsedVariant, expectedImageVariant)
    }
}

private extension CharactersViewModelTests {
    func givenSutWithSuccessfulFetcher() {
        givenSuccessfulCharactersFetcher()
        givenSut()
    }

    func givenSutWithSuccessfulEmptyFetcher() {
        charactersFetcherMock = FetchCharactersUseCaseEmptyStub()
        givenSut()
    }

    func givenSutWithFailingFetcher() {
        charactersFetcherMock = FetchCharactersUseCaseFailingStub()
        givenSut()
    }

    func givenSuccessfulCharactersFetcher() {
        charactersFetcherMock = FetchCharactersUseCaseSuccessfulStub()
    }

    func givenSut() {
        givenSut(pager: offsetPagerMock)
    }

    func givenSut(pager: Pager) {
        sut = CharactersViewModel(
            charactersFetcher: charactersFetcherMock,
            imageURLBuilder: imageURLBuilderMock,
            pager: pager
        )
    }

    func givenSutWithCallRecorder() {
        methodCallRecorder = ViewDelegatePagerCallRecorder()
        givenSut(pager: methodCallRecorder)
    }

    func givenCoordinatorDelegate() {
        sut.coordinatorDelegate = coordinatorDelegateMock
    }

    func givenDidStartSuccessfully() async {
        givenSutWithSuccessfulFetcher()
        await sut.start()
    }

    func givenStartFailed() async {
        givenSutWithFailingFetcher()
        await sut.start()
    }

    func whenWillDisplayCell(atIndex index: Int) async throws -> FetchCharactersQuery {
        await whenWillDisplayCellIgnoringQuery(atIndex: index)
        let mostRecentQuery = try XCTUnwrap(charactersFetcherMock.mostRecentQuery)
        return mostRecentQuery
    }

    func whenWillDisplayCellIgnoringQuery(atIndex index: Int) async {
        await sut.willDisplayCell(at: IndexPath(row: index, section: 0))
    }

    func assertPagerIsAtEndOfCurrentPageWithMoreContent(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(offsetPagerMock.isAtEndOfCurrentPageMoreContentCallCount, callCount, line: line)
    }

    func assertPagerUpdate(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(offsetPagerMock.updateCallCount, callCount, line: line)
    }

    func buildExpectedCellModels(from characters: [Character]) -> [CharacterCellModel] {
        characters.map { character in
            let imageURL = imageURLBuilderMock.buildURL(from: character.image)
            return CharacterCellModel(
                identifier: character.identifier,
                name: character.name,
                description: character.description,
                imageURL: imageURL
            )
        }
    }
}

private class CharactersCoordinatorDelegateMock: CharactersViewModelCoordinatorDelegate {
    var didSelectCallCount = 0

    func model(didSelectCharacterWith _: Int) {
        didSelectCallCount += 1
    }
}
