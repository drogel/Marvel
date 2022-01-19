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

    override func setUp() {
        super.setUp()
        coordinatorDelegateMock = CharactersCoordinatorDelegateMock()
        charactersFetcherMock = CharactersFetcherMock()
        sut = CharactersViewModel(charactersFetcher: charactersFetcherMock)
    }

    override func tearDown() {
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
}

private extension CharactersViewModelTests {

    func givenCoordinatorDelegate() {
        sut.coordinatorDelegate = coordinatorDelegateMock
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
