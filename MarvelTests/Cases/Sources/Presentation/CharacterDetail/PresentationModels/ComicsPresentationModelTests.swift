//
//  ComicsPresentationModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

@testable import Marvel_Debug
import XCTest

class ComicsPresentationModelTests: XCTestCase {
    private var sut: ComicsPresentationModel!
    private var viewDelegate: ComicsPresentationModelViewDelegateMock!
    private var comicFetcherMock: ComicFetcherMock!
    private var imageURLBuilderMock: ImageURLBuilderMock!
    private var offsetPagerMock: OffsetPagerPartialMock!

    override func setUp() {
        super.setUp()
        comicFetcherMock = ComicFetcherMock()
        imageURLBuilderMock = ImageURLBuilderMock()
        offsetPagerMock = OffsetPagerPartialMock()
        givenSut(with: comicFetcherMock)
    }

    override func tearDown() {
        sut = nil
        imageURLBuilderMock = nil
        offsetPagerMock = nil
        comicFetcherMock = nil
        viewDelegate = nil
        super.tearDown()
    }

    func test_conformsToComicsPresentationModelProtocol() {
        XCTAssertTrue((sut as AnyObject) is ComicsPresentationModelProtocol)
    }

    func test_conformsToPresentationModel() {
        XCTAssertTrue((sut as AnyObject) is PresentationModel)
    }

    func test_givenViewDelegate_whenStarting_notifiesLoading() {
        givenViewDelegate()
        assertViewDelegateDidStartLoading(callCount: 0)
        sut.start()
        assertViewDelegateDidStartLoading(callCount: 1)
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

    func test_givenViewDelegate_whenStartingFinishes_notifiesView() {
        givenSutWithSuccessfulFetcher()
        givenViewDelegate()
        assertViewDelegateDidFinishLoading(callCount: 0)
        sut.start()
        assertViewDelegateDidFinishLoading(callCount: 1)
    }

    func test_givenViewDelegate_whenStartingFinishes_updatesPage() {
        givenSutWithSuccessfulFetcher()
        assertPagerUpdate(callCount: 0)
        sut.start()
        assertPagerUpdate(callCount: 1)
    }

    func test_givenViewDelegate_whenStartingFinishesSuccessfully_notifiesView() {
        givenSutWithSuccessfulFetcher()
        givenViewDelegate()
        assertViewDelegateDidRetrieveData(callCount: 0)
        sut.start()
        assertViewDelegateDidRetrieveData(callCount: 1)
    }

    func test_givenViewDelegate_whenStartingFails_notifiesView() {
        givenSutWithFailingFetcher()
        givenViewDelegate()
        assertViewDelegateDidFailRetrievingData(callCount: 0)
        sut.start()
        assertViewDelegateDidFailRetrievingData(callCount: 1)
    }

    func test_givenDidNotStart_hasNoCellData() {
        assertHasNoCellData()
    }

    func test_givenDidStartSuccessfully_hasCellData() {
        givenSutWithSuccessfulFetcher()
        sut.start()
        XCTAssertNotNil(whenRetrievingFirstCellData())
        assertSutNumberOfComics(equals: 1)
    }

    func test_givenDidStartSuccessfully_cellDataHasFormattedFields() {
        givenDidStartSuccessfully()
        XCTAssertNotNil(whenRetrievingFirstCellData())
        let actualCellData = try! XCTUnwrap(whenRetrievingFirstCellData())
        XCTAssertEqual(actualCellData.title, "Test Title")
        let expectedIssueNumber = String(format: "issue_number %@".localized, String(1))
        XCTAssertEqual(actualCellData.issueNumber, expectedIssueNumber)
    }

    func test_givenStartDidFail_hasNoCellData() {
        givenSutWithFailingFetcher()
        sut.start()
        assertHasNoCellData()
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
        assertSutNumberOfComics(equals: 1)
        whenAboutToDisplayACell()
        assertSutNumberOfComics(equals: 2)
    }

    func test_givenDidStartSuccessfully_whenRetrievingComicCells_imageURLBuiltExpectedVariant() throws {
        givenDidStartSuccessfully()
        let expectedImageVariant: ImageVariant = .portraitLarge
        let actualUsedVariant = try XCTUnwrap(imageURLBuilderMock.mostRecentImageVariant)
        XCTAssertEqual(actualUsedVariant, expectedImageVariant)
    }
}

private class ComicsPresentationModelViewDelegateMock: ComicsPresentationModelViewDelegate {
    var didStartLoadingCallCount = 0
    var didFinishLoadingCallCount = 0
    var didRetrieveDataCallCount = 0
    var didFailRetrievingDataCallCount = 0

    func modelDidStartLoading(_: ComicsPresentationModelProtocol) {
        didStartLoadingCallCount += 1
    }

    func modelDidFinishLoading(_: ComicsPresentationModelProtocol) {
        didFinishLoadingCallCount += 1
    }

    func modelDidRetrieveData(_: ComicsPresentationModelProtocol) {
        didRetrieveDataCallCount += 1
    }

    func modelDidFailRetrievingData(_: ComicsPresentationModelProtocol) {
        didFailRetrievingDataCallCount += 1
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

private extension ComicsPresentationModelTests {
    var characterIDStub: Int {
        12345
    }

    func givenViewDelegate() {
        viewDelegate = ComicsPresentationModelViewDelegateMock()
        sut.viewDelegate = viewDelegate
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
        sut = ComicsPresentationModel(
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

    func whenRetrievingFirstCellData() -> ComicCellModel? {
        sut.comicCellModels.first
    }

    func assertViewDelegateDidStartLoading(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewDelegate.didStartLoadingCallCount, callCount, line: line)
    }

    func assertViewDelegateDidFinishLoading(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewDelegate.didFinishLoadingCallCount, callCount, line: line)
    }

    func assertPagerUpdate(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(offsetPagerMock.updateCallCount, callCount, line: line)
    }

    func assertPagerIsAtEndOfCurrentPageWithMoreContent(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(offsetPagerMock.isAtEndOfCurrentPageMoreContentCallCount, callCount, line: line)
    }

    func assertViewDelegateDidRetrieveData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewDelegate.didRetrieveDataCallCount, callCount, line: line)
    }

    func assertViewDelegateDidFailRetrievingData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewDelegate.didFailRetrievingDataCallCount, callCount, line: line)
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

    func assertSutNumberOfComics(equals expectedNumberOfComics: Int, line: UInt = #line) {
        XCTAssertEqual(sut.comicCellModels.count, expectedNumberOfComics, line: line)
    }

    func assertImageURLBuilderBuildVariant(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(imageURLBuilderMock.buildURLVariantCallCount, callCount, line: line)
    }

    func assertHasNoCellData(line: UInt = #line) {
        XCTAssertNil(whenRetrievingFirstCellData(), line: line)
        assertSutNumberOfComics(equals: 0, line: line)
    }

    func whenAboutToDisplayACell() {
        sut.willDisplayComicCell(at: IndexPath(row: 0, section: 0))
    }
}
