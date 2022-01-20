//
//  CharactersViewModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import XCTest
@testable import Marvel_Debug

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
        sut = CharactersViewModel(charactersFetcher: charactersFetcherMock)
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

    func test_givenCoordinatorDelegate_whenSelecting_notifiesDelegate() {
        givenCoordinatorDelegate()
        sut.select(itemAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(coordinatorDelegateMock.didSelectCallCount, 1)
    }

    func test_givenCharactersFetcher_whenStrating_fetchesCharacters() {
        sut.start()
        XCTAssertEqual(charactersFetcherMock.fetchCallCount, 1)
    }

    func test_givenSuccessfulCharactersFetcher_whenStartingCompletes_numberOfItemsIsNotZero() throws {
        givenSutWithSuccessfulFetcher()
        assert(numberOfItems: 0)
        sut.start()
        let expectedNumberOfItems = try XCTUnwrap(CharactersSuccessfulStub.pageInfoStub.results?.count)
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
}

private extension CharactersViewModelTests {

    func givenSutWithSuccessfulFetcher() {
        sut = CharactersViewModel(charactersFetcher: CharactersSuccessfulStub())
    }

    func givenViewDelegate() {
        sut.viewDelegate = viewDelegateMock
    }

    func givenCoordinatorDelegate() {
        sut.coordinatorDelegate = coordinatorDelegateMock
    }

    func assert(numberOfItems: Int, line: UInt = #line) {
        XCTAssertEqual(sut.numberOfItems, numberOfItems, line: line)
    }
}

private class CharactersCoordinatorDelegateMock: CharactersViewModelCoordinatorDelegate {
    var didSelectCallCount = 0

    func viewModel(_ viewModel: CharactersViewModelProtocol, didSelectItemAt indexPath: IndexPath) {
        didSelectCallCount += 1
    }
}

private class CharactersFetcherMock: FetchCharactersUseCaseProtocol {

    var fetchCallCount = 0

    func fetch(query: FetchCharactersQuery, completion: @escaping (Result<PageInfo, Error>) -> Void) -> Cancellable? {
        fetchCallCount += 1
        return nil
    }
}

private class CharactersSuccessfulStub: FetchCharactersUseCaseProtocol {

    static let pageInfoStub = PageInfo.zeroWith(results: [CharacterData.aginar, CharacterData.aginar])

    func fetch(query: FetchCharactersQuery, completion: @escaping (Result<PageInfo, Error>) -> Void) -> Cancellable? {
        completion(.success(Self.pageInfoStub))
        return nil
    }
}

private class CharactersViewModelViewDelegateMock: CharactersViewModelViewDelegate {

    var didUpdateCallCount = 0
    var didStartLoadingCallCount = 0
    var didFinishLoadingCallCount = 0

    func viewModelDidUpdateItems(_ viewModel: CharactersViewModelProtocol) {
        didUpdateCallCount += 1
    }

    func viewModelDidStartLoading(_ viewModel: CharactersViewModelProtocol) {
        didStartLoadingCallCount += 1
    }

    func viewModelDidFinishLoading(_ viewModel: CharactersViewModelProtocol) {
        didFinishLoadingCallCount += 1
    }
}
