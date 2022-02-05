//
//  CharactersViewModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

@testable import Marvel_Debug
import XCTest

class CharactersViewModelTests: XCTestCase {
    private var sut: CharactersViewModel!
    private var coordinatorDelegateMock: CharactersCoordinatorDelegateMock!
    private var charactersFetcherMock: CharactersFetcherMock!
    private var viewDelegateMock: CharactersViewModelViewDelegateMock!

    override func setUp() {
        super.setUp()
        viewDelegateMock = CharactersViewModelViewDelegateMock()
        coordinatorDelegateMock = CharactersCoordinatorDelegateMock()
        charactersFetcherMock = CharactersFetcherMock()
        sut = CharactersViewModel(charactersFetcher: charactersFetcherMock, imageURLBuilder: ImageURLBuilderStub())
    }

    override func tearDown() {
        viewDelegateMock = nil
        charactersFetcherMock = nil
        coordinatorDelegateMock = nil
        sut = nil
        super.tearDown()
    }

    func test_conformsToViewModel() {
        XCTAssertTrue((sut as AnyObject) is ViewModel)
    }

    func test_conformsToCharactersViewModel() {
        XCTAssertTrue((sut as AnyObject) is CharactersViewModelProtocol)
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

    func test_givenSuccessfulCharactersFetcher_whenStartingCompletes_numberOfItemsIsNotZero() {
        givenSutWithSuccessfulFetcher()
        assert(numberOfItems: 0)
        sut.start()
        let expectedNumberOfItems = CharactersFetcherSuccessfulStub.resultsStub.count
        assert(numberOfItems: expectedNumberOfItems)
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

    func test_whenRetrievingCellData_returnsNilIfDidNotFetchYet() {
        XCTAssertNil(sut.cellData(at: IndexPath(item: 0, section: 0)))
    }

    func test_givenDidStartSuccessfully_whenRetrievingCellDataAtValidIndex_returnsData() throws {
        givenDidStartSuccessfully()
        let actual = try XCTUnwrap(sut.cellData(at: IndexPath(item: 0, section: 0)))
        XCTAssertEqual(actual.name, "Aginar")
        XCTAssertEqual(actual.description, "")
    }

    func test_givenDidStartSuccessfully_whenRetrievingCellDataAtInvalidIndex_returnsNil() {
        givenDidStartSuccessfully()
        XCTAssertNil(sut.cellData(at: IndexPath(row: -1, section: 0)))
    }

    func test_whenWillDisplayCellFromIndexZero_doesNotFetch() {
        whenWillDisplayCellIgnoringQuery(atIndex: 0)
        XCTAssertNil(charactersFetcherMock.mostRecentQuery)
        XCTAssertEqual(charactersFetcherMock.fetchCallCount, 0)
    }

    func test_givenDidStartSuccessfully_whenWillDisplayCell_fetchesCharactersFromLoadedCharactersCountOffset() {
        givenDidStartSuccessfully()
        let mostRecentQuery = whenWillDisplayCell(atIndex: CharactersFetcherSuccessfulStub.resultsStub.count - 1)
        XCTAssertEqual(mostRecentQuery.offset, CharactersFetcherSuccessfulStub.resultsStub.count)
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
}

private extension CharactersViewModelTests {
    func givenSutWithSuccessfulFetcher() {
        charactersFetcherMock = CharactersFetcherSuccessfulStub()
        givenSut(with: charactersFetcherMock)
    }

    func givenSutWithSuccessfulEmptyFetcher() {
        charactersFetcherMock = CharactersFetcherSuccessfulEmptyStub()
        givenSut(with: charactersFetcherMock)
    }

    func givenSutWithFailingFetcher() {
        charactersFetcherMock = CharactersFetcherFailingStub()
        givenSut(with: charactersFetcherMock)
    }

    func givenSut(with _: FetchCharactersUseCase) {
        sut = CharactersViewModel(charactersFetcher: charactersFetcherMock, imageURLBuilder: ImageURLBuilderStub())
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

    func retrieveFetcherMockCancellableMock() -> CancellableMock {
        try! XCTUnwrap(charactersFetcherMock.cancellable)
    }

    func whenWillDisplayCellIgnoringQuery(atIndex index: Int) {
        sut.willDisplayCell(at: IndexPath(row: index, section: 0))
    }

    func assertCancelledRequests(line: UInt = #line) {
        let cancellableMock = retrieveFetcherMockCancellableMock()
        XCTAssertEqual(cancellableMock.didCancelCallCount, 1, line: line)
    }

    func assert(numberOfItems: Int, line: UInt = #line) {
        XCTAssertEqual(sut.numberOfItems, numberOfItems, line: line)
    }
}

private class CharactersCoordinatorDelegateMock: CharactersViewModelCoordinatorDelegate {
    var didSelectCallCount = 0

    func viewModel(_: CharactersViewModelProtocol, didSelectCharacterWith _: Int) {
        didSelectCallCount += 1
    }
}

private class CharactersFetcherMock: FetchCharactersUseCase {
    var fetchCallCount = 0
    var mostRecentQuery: FetchCharactersQuery?

    var cancellable: CancellableMock?

    func fetch(query: FetchCharactersQuery, completion _: @escaping (FetchCharactersResult) -> Void) -> Cancellable? {
        fetchCallCount += 1
        mostRecentQuery = query
        cancellable = CancellableMock()
        return cancellable
    }
}

private class CharactersFetcherSuccessfulStub: CharactersFetcherMock {
    static let resultsStub = [CharacterData.aginar, CharacterData.aginar]
    static let pageInfoStub = PageInfo<CharacterData>.zeroWith(results: resultsStub)

    override func fetch(
        query: FetchCharactersQuery,
        completion: @escaping (FetchCharactersResult) -> Void
    ) -> Cancellable? {
        let result = super.fetch(query: query, completion: completion)
        completion(.success(Self.pageInfoStub))
        return result
    }
}

private class CharactersFetcherSuccessfulEmptyStub: CharactersFetcherMock {
    override func fetch(
        query: FetchCharactersQuery,
        completion: @escaping (FetchCharactersResult) -> Void
    ) -> Cancellable? {
        let result = super.fetch(query: query, completion: completion)
        completion(.success(PageInfo<CharacterData>.empty))
        return result
    }
}

private class CharactersFetcherFailingStub: CharactersFetcherMock {
    override func fetch(
        query: FetchCharactersQuery,
        completion: @escaping (FetchCharactersResult) -> Void
    ) -> Cancellable? {
        let result = super.fetch(query: query, completion: completion)
        completion(.failure(.unauthorized))
        return result
    }
}

private class CharactersViewModelViewDelegateMock: CharactersViewModelViewDelegate {
    var didUpdateCallCount = 0
    var didStartLoadingCallCount = 0
    var didFinishLoadingCallCount = 0
    var didFailCallCount = 0

    func viewModelDidUpdateItems(_: CharactersViewModelProtocol) {
        didUpdateCallCount += 1
    }

    func viewModelDidStartLoading(_: CharactersViewModelProtocol) {
        didStartLoadingCallCount += 1
    }

    func viewModelDidFinishLoading(_: CharactersViewModelProtocol) {
        didFinishLoadingCallCount += 1
    }

    func viewModel(_: CharactersViewModelProtocol, didFailWithError _: String) {
        didFailCallCount += 1
    }
}
