//
//  ComicsViewModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

@testable import Marvel_Debug
import XCTest

class ComicsViewModelTests: XCTestCase {
    private var sut: ComicsViewModel!
    private var viewDelegate: ComicsViewModelViewDelegateMock!
    private var comicFetcherMock: ComicFetcherMock!

    override func setUp() {
        super.setUp()
        comicFetcherMock = ComicFetcherMock()
        givenSut(with: comicFetcherMock)
    }

    override func tearDown() {
        sut = nil
        comicFetcherMock = nil
        viewDelegate = nil
        super.tearDown()
    }

    func test_conformsToComicsViewModelProtocol() {
        XCTAssertTrue((sut as AnyObject) is ComicsViewModelProtocol)
    }

    func test_conformsToViewModel() {
        XCTAssertTrue((sut as AnyObject) is ViewModel)
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

    func test_givenViewModelStarted_whenDisposing_cancellsCancellable() {
        sut.start()
        assertComicFetcherFetchLastCancellableDidCancel(callCount: 0)
        sut.dispose()
        assertComicFetcherFetchLastCancellableDidCancel(callCount: 1)
    }

    func test_givenViewModelStarted_whenStartingAgain_cancellsCancellable() {
        sut.start()
        assertComicFetcherFetchFirstCancellableDidCancel(callCount: 0)
        sut.start()
        assertComicFetcherFetchFirstCancellableDidCancel(callCount: 1)
    }

    func test_givenViewDelegate_whenStartingFinishes_notifiesView() {
        givenSutWithSuccessfulFetcher()
        givenViewDelegate()
        assertViewDelegateDidFinishLoading(callCount: 0)
        sut.start()
        assertViewDelegateDidFinishLoading(callCount: 1)
    }
}

private class ComicsViewModelViewDelegateMock: ComicsViewModelViewDelegate {
    var didStartLoadingCallCount = 0
    var didFinishLoadingCallCount = 0

    func viewModelDidStartLoading(_: ComicsViewModelProtocol) {
        didStartLoadingCallCount += 1
    }

    func viewModelDidFinishLoading(_: ComicsViewModelProtocol) {
        didFinishLoadingCallCount += 1
    }
}

private class ComicFetcherMock: FetchComicsUseCase {
    var fetchCallCount = 0
    var mostRecentQuery: FetchComicsQuery?
    var cancellables: [CancellableMock] = []

    func fetch(query: FetchComicsQuery, completion _: @escaping (FetchComicsResult) -> Void) -> Cancellable? {
        fetchCallCount += 1
        mostRecentQuery = query
        cancellables.append(CancellableMock())
        return cancellables.last
    }
}

private class ComicFetcherSuccessfulStub: ComicFetcherMock {
    override func fetch(query: FetchComicsQuery, completion: @escaping (FetchComicsResult) -> Void) -> Cancellable? {
        let cancellable = super.fetch(query: query, completion: completion)
        completion(.success(PageInfo.empty))
        return cancellable
    }
}

private extension ComicsViewModelTests {
    var characterIDStub: Int {
        12345
    }

    func givenViewDelegate() {
        viewDelegate = ComicsViewModelViewDelegateMock()
        sut.viewDelegate = viewDelegate
    }

    func givenSutWithSuccessfulFetcher() {
        comicFetcherMock = ComicFetcherSuccessfulStub()
        givenSut(with: comicFetcherMock)
    }

    func givenSut(with comicsFetcher: ComicFetcherMock) {
        sut = ComicsViewModel(comicsFetcher: comicsFetcher, characterID: characterIDStub)
    }

    func assertViewDelegateDidStartLoading(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewDelegate.didStartLoadingCallCount, callCount, line: line)
    }

    func assertViewDelegateDidFinishLoading(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewDelegate.didFinishLoadingCallCount, callCount, line: line)
    }

    func assertComicFetcherFetch(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicFetcherMock.fetchCallCount, callCount, line: line)
    }

    func assertComicFetcherFetchLastCancellableDidCancel(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicFetcherMock.cancellables.last?.didCancelCallCount, callCount, line: line)
    }

    func assertComicFetcherFetchFirstCancellableDidCancel(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicFetcherMock.cancellables.first?.didCancelCallCount, callCount, line: line)
    }
}
