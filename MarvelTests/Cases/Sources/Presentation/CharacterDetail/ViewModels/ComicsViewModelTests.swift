//
//  ComicsViewModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Combine
@testable import Marvel_Debug
import XCTest

class ComicsViewModelTests: XCTestCase {
    private var sut: ComicsViewModel!
    private var comicFetcherMock: ComicFetcherMock!
    private var imageURLBuilderMock: ImageURLBuilderMock!
    private var offsetPagerMock: OffsetPagerPartialMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        comicFetcherMock = ComicFetcherMock()
        imageURLBuilderMock = ImageURLBuilderMock()
        offsetPagerMock = OffsetPagerPartialMock()
        givenSut(with: comicFetcherMock)
    }

    override func tearDown() {
        sut = nil
        imageURLBuilderMock = nil
        offsetPagerMock = nil
        cancellables = nil
        comicFetcherMock = nil
        super.tearDown()
    }

    func test_conformsToComicsViewModelProtocol() {
        XCTAssertTrue((sut as AnyObject) is ComicsViewModelProtocol)
    }

    func test_conformsToPresentationModel() {
        XCTAssertTrue((sut as AnyObject) is PresentationModel)
    }

    func test_whenStarting_fetchesComics() {
        assertComicFetcherFetch(callCount: 0)
        sut.start()
        assertComicFetcherFetch(callCount: 1)
    }

    func test_whenStarting_fethcesWithStartingQuery() {
        let expectedQuery = FetchComicsQuery(characterID: characterIDStub, offset: 0)
        sut.start()
        XCTAssertEqual(comicFetcherMock.mostRecentQuery, expectedQuery)
    }

    func test_givenPresentationModelStarted_whenDisposing_disposesDisposable() {
        sut.start()
        assertComicFetcherFetchLastDisposableDidCancel(callCount: 0)
        sut.dispose()
        assertComicFetcherFetchLastDisposableDidCancel(callCount: 1)
    }

    func test_givenPresentationModelStarted_whenStartingAgain_disposesDisposable() {
        sut.start()
        assertComicFetcherFetchFirstDisposableDidCancel(callCount: 0)
        sut.start()
        assertComicFetcherFetchFirstDisposableDidCancel(callCount: 1)
    }

    func test_whenStartingFinishes_updatesPage() {
        givenSutWithSuccessfulFetcher()
        assertPagerUpdate(callCount: 0)
        sut.start()
        assertPagerUpdate(callCount: 1)
    }

    func test_whenInitializing_emitsEmptyComicCellModels() {
        givenSutWithSuccessfulFetcher()
        assertEmitsEmptyComicCellModels()
    }

    func test_whenStartingFails_onlyEmptyComicCellModelsAreEmitted() {
        givenSutWithFailingFetcher()
        assertEmitsEmptyComicCellModels()
        sut.start()
    }

    func test_givenDidNotStart_hasNoCellData() {
        subscribeToModelsExpectingNoCellModels()
    }

    func test_givenDidStartSuccessfully_hasCellExpectedModels() {
        givenSutWithSuccessfulFetcher()
        let hasCellModelsExpectation = expectation(description: "Has comics cell models")
        let expectedIssue = String(format: "issue_number %@".localized, String(1))
        let expectedComicCellModel = ComicCellModel(title: "Test Title", issueNumber: expectedIssue, imageURL: nil)
        let expectedComicCellModels = [expectedComicCellModel]
        sut.comicCellModelsPublisher
            .dropFirst()
            .assertOutput(matches: expectedComicCellModels, expectation: hasCellModelsExpectation)
            .store(in: &cancellables)
        sut.start()
        wait(for: [hasCellModelsExpectation], timeout: 0.1)
    }

    func test_givenStartDidFail_hasNoCellData() {
        givenSutWithFailingFetcher()
        sut.start()
        subscribeToModelsExpectingNoCellModels()
    }

    func test_givenDidStartSuccessfully_callsImageURLBuilderBuildWithVariant() {
        givenSutWithSuccessfulFetcher()
        assertImageURLBuilderBuildVariant(callCount: 0)
        sut.start()
        assertImageURLBuilderBuildVariant(callCount: 1)
    }

    func test_givenDidStartSuccessfully_whenAboutToDisplayLastCell_fetchesComics() {
        givenDidStartSuccessfully()
        assertComicFetcherFetch(callCount: 1)
        whenAboutToDisplayACell()
        assertComicFetcherFetch(callCount: 2)
    }

    func test_givenDidStartSuccessfully_whenAboutToDisplayACell_disposesDisposable() {
        givenDidStartSuccessfully()
        assertComicFetcherFetchFirstDisposableDidCancel(callCount: 0)
        whenAboutToDisplayACell()
        assertComicFetcherFetchFirstDisposableDidCancel(callCount: 1)
    }

    func test_givenDidStartSuccessfully_whenAboutToDisplayACell_checksForMoreContent() {
        givenDidStartSuccessfully()
        assertPagerIsAtEndOfCurrentPageWithMoreContent(callCount: 0)
        whenAboutToDisplayACell()
        assertPagerIsAtEndOfCurrentPageWithMoreContent(callCount: 1)
    }

    func test_givenDidStartSuccessfully_whenAboutToDisplayACell_queryIsAtCurrentComicsOffset() {
        givenDidStartSuccessfully()
        whenAboutToDisplayACell()
        XCTAssertEqual(comicFetcherMock.mostRecentQuery?.offset, 1)
    }

    func test_whenAboutToDisplayACell_onlyFetchesComicsIfCellIsLastInPage() {
        assertComicFetcherFetch(callCount: 0)
        whenAboutToDisplayACell()
        assertComicFetcherFetch(callCount: 0)
    }

    func test_givenDidStartSuccessfully_whenAboutToDisplayACell_comicCellsAreAppended() {
        givenDidStartSuccessfully()
        let newValueExpectation = expectation(description: "Received a new value")
        sut.comicCellModelsPublisher
            .dropFirst()
            .assertReceivedValueNotNil(expectation: newValueExpectation)
            .store(in: &cancellables)
        whenAboutToDisplayACell()
        wait(for: [newValueExpectation], timeout: 0.1)
    }

    func test_givenDidStartSuccessfully_whenRetrievingComicCells_imageURLBuiltExpectedVariant() throws {
        givenDidStartSuccessfully()
        let expectedImageVariant: ImageVariant = .portraitLarge
        let actualUsedVariant = try XCTUnwrap(imageURLBuilderMock.mostRecentImageVariant)
        XCTAssertEqual(actualUsedVariant, expectedImageVariant)
    }
}

private class ComicFetcherMock: FetchComicsUseCase {
    var fetchCallCount = 0
    var mostRecentQuery: FetchComicsQuery?
    var disposables: [DisposableMock] = []

    func fetch(query: FetchComicsQuery, completion _: @escaping (FetchComicsResult) -> Void) -> Disposable? {
        fetchCallCount += 1
        mostRecentQuery = query
        disposables.append(DisposableMock())
        return disposables.last
    }
}

private class ComicFetcherSuccessfulStub: ComicFetcherMock {
    static let comicStub = Comic(
        identifier: 0,
        title: "Test #1 Title #1123",
        issueNumber: 1,
        image: Image(path: "", imageExtension: "")
    )
    static let contentPageStub = ContentPage<Comic>.atFirstPageOfTwoTotal(
        contents: [ComicFetcherSuccessfulStub.comicStub]
    )

    override func fetch(query: FetchComicsQuery, completion: @escaping (FetchComicsResult) -> Void) -> Disposable? {
        let diposable = super.fetch(query: query, completion: completion)
        completion(.success(Self.contentPageStub))
        return diposable
    }
}

private class ComicFetcherFailureStub: ComicFetcherMock {
    override func fetch(query: FetchComicsQuery, completion: @escaping (FetchComicsResult) -> Void) -> Disposable? {
        let disposable = super.fetch(query: query, completion: completion)
        completion(.failure(.emptyData))
        return disposable
    }
}

private extension ComicsViewModelTests {
    var characterIDStub: Int {
        12345
    }

    func givenSutWithSuccessfulFetcher() {
        comicFetcherMock = ComicFetcherSuccessfulStub()
        givenSut(with: comicFetcherMock)
    }

    func givenSutWithFailingFetcher() {
        comicFetcherMock = ComicFetcherFailureStub()
        givenSut(with: comicFetcherMock)
    }

    func givenSut(with comicsFetcher: ComicFetcherMock) {
        sut = ComicsViewModel(
            comicsFetcher: comicsFetcher,
            characterID: characterIDStub,
            imageURLBuilder: imageURLBuilderMock,
            pager: offsetPagerMock
        )
    }

    func givenDidStartSuccessfully() {
        givenSutWithSuccessfulFetcher()
        sut.start()
    }

    func assertPagerUpdate(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(offsetPagerMock.updateCallCount, callCount, line: line)
    }

    func assertPagerIsAtEndOfCurrentPageWithMoreContent(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(offsetPagerMock.isAtEndOfCurrentPageMoreContentCallCount, callCount, line: line)
    }

    func assertComicFetcherFetch(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicFetcherMock.fetchCallCount, callCount, line: line)
    }

    func assertComicFetcherFetchLastDisposableDidCancel(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicFetcherMock.disposables.last?.didDisposeCallCount, callCount, line: line)
    }

    func assertComicFetcherFetchFirstDisposableDidCancel(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicFetcherMock.disposables.first?.didDisposeCallCount, callCount, line: line)
    }

    func assertImageURLBuilderBuildVariant(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(imageURLBuilderMock.buildURLVariantCallCount, callCount, line: line)
    }

    func assertEmitsEmptyComicCellModels(line: UInt = #line) {
        let hasEmptyCellModelsExpectation = expectation(description: "Has empty comics cell models")
        sut.comicCellModelsPublisher
            .assertOutputIsEmptyArray(expectation: hasEmptyCellModelsExpectation, line: line)
            .store(in: &cancellables)
        wait(for: [hasEmptyCellModelsExpectation], timeout: 0.1)
    }

    func subscribeToModelsExpectingNoCellModels(line: UInt = #line) {
        let hasCellModelsExpectation = expectation(description: "Has no comic cell models")
        sut.comicCellModelsPublisher
            .assertOutputIsEmptyArray(expectation: hasCellModelsExpectation, line: line)
            .store(in: &cancellables)
        wait(for: [hasCellModelsExpectation], timeout: 0.1)
    }

    func whenAboutToDisplayACell() {
        sut.willDisplayComicCell(at: IndexPath(row: 0, section: 0))
    }
}
