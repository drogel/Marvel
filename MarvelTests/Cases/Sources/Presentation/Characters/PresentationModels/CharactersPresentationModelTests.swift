//
//  CharactersPresentationModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import Combine
@testable import Marvel_Debug
import XCTest

class CharactersPresentationModelTests: XCTestCase {
    private var sut: CharactersPresentationModel!
    private var coordinatorDelegateMock: CharactersCoordinatorDelegateMock!
    private var charactersFetcherMock: CharactersFetcherMock!
    private var viewDelegateMock: CharactersPresentationModelDelegateMock!
    private var offsetPagerMock: OffsetPagerPartialMock!
    private var methodCallRecorder: ViewDelegatePagerCallRecorder!
    private var imageURLBuilderMock: ImageURLBuilderMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewDelegateMock = CharactersPresentationModelDelegateMock()
        coordinatorDelegateMock = CharactersCoordinatorDelegateMock()
        charactersFetcherMock = CharactersFetcherMock()
        offsetPagerMock = OffsetPagerPartialMock()
        imageURLBuilderMock = ImageURLBuilderMock()
        cancellables = Set<AnyCancellable>()
        givenSut()
    }

    override func tearDown() {
        viewDelegateMock = nil
        charactersFetcherMock = nil
        coordinatorDelegateMock = nil
        offsetPagerMock = nil
        imageURLBuilderMock = nil
        methodCallRecorder = nil
        cancellables = nil
        sut = nil
        super.tearDown()
    }

    func test_conformsToPresentationModel() {
        XCTAssertTrue((sut as AnyObject) is PresentationModel)
    }

    func test_conformsToCharactersPresentationModel() {
        XCTAssertTrue((sut as AnyObject) is CharactersPresentationModelProtocol)
    }

    func test_givenDidStartSuccessfullyAndACoordinatorDelegate_whenSelecting_notifiesDelegate() {
        givenDidStartSuccessfully()
        givenCoordinatorDelegate()
        sut.select(at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(coordinatorDelegateMock.didSelectCallCount, 1)
    }

    func test_givenCharactersFetcher_whenStrating_fetchesCharacters() {
        sut.start()
        XCTAssertEqual(charactersFetcherMock.fetchCallCount, 1)
    }

    func test_givenViewDelegate_whenStarting_notifiesLoadingToViewDelegate() {
        givenViewDelegate()
        sut.start()
        XCTAssertEqual(viewDelegateMock.didStartLoadingCallCount, 1)
    }

    func test_givenViewDelegate_whenStartingCompletesSuccessfully_notifiesViewDelegate() {
        givenSutWithSuccessfulFetcher()
        givenViewDelegate()
        sut.start()
        XCTAssertEqual(viewDelegateMock.didUpdateCallCount, 1)
    }

    func test_givenViewDelegate_whenStartingCompletesSuccessfully_notifiesFinishLoadToViewDelegate() {
        givenSutWithSuccessfulFetcher()
        givenViewDelegate()
        sut.start()
        XCTAssertEqual(viewDelegateMock.didFinishLoadingCallCount, 1)
    }

    func test_givenDidNotFetchYet_whenRetrievingCellData_publishesEmptyArray() {
        // TODO: Extract this to reuse in tests
        let receivedValueExpectation = expectation(description: "Publishes single value")
        sut.cellModelsPublisher
            .sink { receivedModels in
                XCTAssertTrue(receivedModels.isEmpty)
                receivedValueExpectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [receivedValueExpectation], timeout: 0.1)
    }

    func test_givenSutWithSuccessfulFetcher_whenStarting_publishesSingleDataAfterDroppingInitial() throws {
        givenSutWithSuccessfulFetcher()
        // TODO: Extract this to reuse in tests
        let receivedValueExpectation = expectation(description: "Publishes single value")
        let expectedModels = buildExpectedCellModels(from: CharactersFetcherSuccessfulStub.charactersStub)
        sut.cellModelsPublisher
            .dropFirst()
            .sink { receivedModels in
                XCTAssertEqual(receivedModels, expectedModels)
                receivedValueExpectation.fulfill()
            }
            .store(in: &cancellables)

        sut.start()
        wait(for: [receivedValueExpectation], timeout: 0.1)
    }

    func test_whenWillDisplayCellFromIndexZero_doesNotFetch() {
        whenWillDisplayCellIgnoringQuery(atIndex: 0)
        XCTAssertNil(charactersFetcherMock.mostRecentQuery)
        XCTAssertEqual(charactersFetcherMock.fetchCallCount, 0)
    }

    func test_givenDidStartSuccessfully_whenWillDisplayCell_fetchesCharactersFromLoadedCharactersCountOffset() {
        givenDidStartSuccessfully()
        let mostRecentQuery = whenWillDisplayCell(atIndex: CharactersFetcherSuccessfulStub.charactersStub.count - 1)
        XCTAssertEqual(mostRecentQuery.offset, CharactersFetcherSuccessfulStub.charactersStub.count)
    }

    func test_givenStartFailed_whenWillDisplayCell_doesNotFetch() {
        givenStartFailed()
        let mostRecentQuery = whenWillDisplayCell(atIndex: 0)
        XCTAssertEqual(mostRecentQuery.offset, 0)
    }

    func test_givenDidStartSuccessfully_whenDisposing_cancellsRequests() {
        givenDidStartSuccessfully()
        sut.dispose()
        assertCancelledRequests()
    }

    func test_givenStartFailed_whenDisposing_cancellsRequests() {
        givenStartFailed()
        sut.dispose()
        assertCancelledRequests()
    }

    func test_givenStartFailed_notifiesViewDelegate() {
        givenSutWithFailingFetcher()
        givenViewDelegate()
        sut.start()
        XCTAssertEqual(viewDelegateMock.didFailCallCount, 1)
    }

    func test_givenViewDelegate_whenStartingFinishes_updatesPage() {
        givenSutWithSuccessfulFetcher()
        assertPagerUpdate(callCount: 0)
        sut.start()
        assertPagerUpdate(callCount: 1)
    }

    func test_givenDidStartSuccessfully_whenAboutToDisplayACell_checksForMoreContent() {
        givenDidStartSuccessfully()
        assertPagerIsAtEndOfCurrentPageWithMoreContent(callCount: 0)
        whenWillDisplayCellIgnoringQuery(atIndex: 0)
        assertPagerIsAtEndOfCurrentPageWithMoreContent(callCount: 1)
    }

    func test_givenDidStartSuccessfully_whenAboutToDisplayACell_updateNotificationsAreCalledInOrder() {
        let expectedCalls: [ViewDelegatePagerCallRecorder.Method] = [
            .isAtEndOfCurrentPageWithMoreContent,
            .modelDidFinishLoading,
            .modelDidUpdateItems,
            .update,
        ]
        givenSuccessfulCharactersFetcher()
        givenSutWithCallRecorder()
        whenWillDisplayCellIgnoringQuery(atIndex: 0)
        XCTAssertEqual(methodCallRecorder.methodsCalled, expectedCalls)
    }

    func test_givenDidStartSuccessfully_whenRetrievingCharacters_imageURLBuiltExpectedVariant() throws {
        givenDidStartSuccessfully()
        let expectedImageVariant: ImageVariant = .detail
        let actualUsedVariant = try XCTUnwrap(imageURLBuilderMock.mostRecentImageVariant)
        XCTAssertEqual(actualUsedVariant, expectedImageVariant)
    }
}

private extension CharactersPresentationModelTests {
    func givenSutWithSuccessfulFetcher() {
        givenSuccessfulCharactersFetcher()
        givenSut()
    }

    func givenSutWithSuccessfulEmptyFetcher() {
        charactersFetcherMock = CharactersFetcherSuccessfulEmptyStub()
        givenSut()
    }

    func givenSutWithFailingFetcher() {
        charactersFetcherMock = CharactersFetcherFailingStub()
        givenSut()
    }

    func givenSuccessfulCharactersFetcher() {
        charactersFetcherMock = CharactersFetcherSuccessfulStub()
    }

    func givenSut() {
        givenSut(pager: offsetPagerMock)
    }

    func givenSut(pager: Pager) {
        sut = CharactersPresentationModel(
            charactersFetcher: charactersFetcherMock,
            imageURLBuilder: imageURLBuilderMock,
            pager: pager
        )
    }

    func givenSutWithCallRecorder() {
        methodCallRecorder = ViewDelegatePagerCallRecorder()
        givenSut(pager: methodCallRecorder)
        sut.viewDelegate = methodCallRecorder
    }

    func givenViewDelegate() {
        sut.viewDelegate = viewDelegateMock
    }

    func givenCoordinatorDelegate() {
        sut.coordinatorDelegate = coordinatorDelegateMock
    }

    func givenDidStartSuccessfully() {
        givenSutWithSuccessfulFetcher()
        sut.start()
    }

    func givenStartFailed() {
        givenSutWithFailingFetcher()
        sut.start()
    }

    func whenWillDisplayCell(atIndex index: Int) -> FetchCharactersQuery {
        whenWillDisplayCellIgnoringQuery(atIndex: index)
        let mostRecentQuery = try! XCTUnwrap(charactersFetcherMock.mostRecentQuery)
        return mostRecentQuery
    }

    func retrieveFetcherMockCancellableMock() -> DisposableMock {
        try! XCTUnwrap(charactersFetcherMock.cancellable)
    }

    func whenWillDisplayCellIgnoringQuery(atIndex index: Int) {
        sut.willDisplayCell(at: IndexPath(row: index, section: 0))
    }

    func assertCancelledRequests(line: UInt = #line) {
        let cancellableMock = retrieveFetcherMockCancellableMock()
        XCTAssertEqual(cancellableMock.didDisposeCallCount, 1, line: line)
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

private class CharactersCoordinatorDelegateMock: CharactersPresentationModelCoordinatorDelegate {
    var didSelectCallCount = 0

    func model(_: CharactersPresentationModelProtocol, didSelectCharacterWith _: Int) {
        didSelectCallCount += 1
    }
}

private class CharactersFetcherMock: FetchCharactersUseCase {
    var fetchCallCount = 0
    var mostRecentQuery: FetchCharactersQuery?

    var cancellable: DisposableMock?

    func fetch(query: FetchCharactersQuery, completion _: @escaping (FetchCharactersResult) -> Void) -> Disposable? {
        fetchCallCount += 1
        mostRecentQuery = query
        cancellable = DisposableMock()
        return cancellable
    }
}

private class CharactersFetcherSuccessfulStub: CharactersFetcherMock {
    static let charactersStub = [Character.aginar]
    static let contentPageStub = ContentPage<Character>.atFirstPageOfTwoTotal(contents: charactersStub)

    override func fetch(
        query: FetchCharactersQuery,
        completion: @escaping (FetchCharactersResult) -> Void
    ) -> Disposable? {
        let result = super.fetch(query: query, completion: completion)
        completion(.success(Self.contentPageStub))
        return result
    }
}

private class CharactersFetcherSuccessfulEmptyStub: CharactersFetcherMock {
    override func fetch(
        query: FetchCharactersQuery,
        completion: @escaping (FetchCharactersResult) -> Void
    ) -> Disposable? {
        let result = super.fetch(query: query, completion: completion)
        completion(.success(ContentPage<Character>.empty))
        return result
    }
}

private class CharactersFetcherFailingStub: CharactersFetcherMock {
    override func fetch(
        query: FetchCharactersQuery,
        completion: @escaping (FetchCharactersResult) -> Void
    ) -> Disposable? {
        let result = super.fetch(query: query, completion: completion)
        completion(.failure(.unauthorized))
        return result
    }
}

private class CharactersPresentationModelDelegateMock: CharactersPresentationModelViewDelegate {
    var didUpdateCallCount = 0
    var didStartLoadingCallCount = 0
    var didFinishLoadingCallCount = 0
    var didFailCallCount = 0

    func modelDidUpdateItems(_: CharactersPresentationModelProtocol) {
        didUpdateCallCount += 1
    }

    func modelDidStartLoading(_: CharactersPresentationModelProtocol) {
        didStartLoadingCallCount += 1
    }

    func modelDidFinishLoading(_: CharactersPresentationModelProtocol) {
        didFinishLoadingCallCount += 1
    }

    func model(_: CharactersPresentationModelProtocol, didFailWithError _: String) {
        didFailCallCount += 1
    }
}

private class ViewDelegatePagerCallRecorder: CharactersPresentationModelViewDelegate, Pager {
    enum Method: String, CustomDebugStringConvertible {
        case isAtEndOfCurrentPageWithMoreContent
        case modelDidFinishLoading
        case modelDidUpdateItems
        case update

        var debugDescription: String {
            rawValue
        }
    }

    var methodsCalled: [Method] = []

    func modelDidStartLoading(_: CharactersPresentationModelProtocol) {}

    func modelDidFinishLoading(_: CharactersPresentationModelProtocol) {
        methodsCalled.append(.modelDidFinishLoading)
    }

    func modelDidUpdateItems(_: CharactersPresentationModelProtocol) {
        methodsCalled.append(.modelDidUpdateItems)
    }

    func model(_: CharactersPresentationModelProtocol, didFailWithError _: String) {}

    func isThereMoreContent(at _: Int) -> Bool {
        true
    }

    func isAtEndOfCurrentPage(_: Int) -> Bool {
        true
    }

    func isAtEndOfCurrentPageWithMoreContent(_: Int) -> Bool {
        methodsCalled.append(.isAtEndOfCurrentPageWithMoreContent)
        return true
    }

    func update(currentPage _: Page) {
        methodsCalled.append(.update)
    }
}
