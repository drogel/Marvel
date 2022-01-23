//
//  CharacterDetailViewModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

import XCTest
@testable import Marvel_Debug

class CharacterDetailViewModelTests: XCTestCase {

    private var sut: CharacterDetailViewModel!
    private var characterFetcherMock: CharacterFetcherMock!
    private var viewDelegateMock: CharacterDetailViewModelViewDelegateMock!

    override func setUp() {
        super.setUp()
        characterFetcherMock = CharacterFetcherMock()
        viewDelegateMock = CharacterDetailViewModelViewDelegateMock()
        sut = CharacterDetailViewModel(characterFetcher: characterFetcherMock)
    }

    override func tearDown() {
        characterFetcherMock = nil
        viewDelegateMock = nil
        sut = nil
        super.tearDown()
    }

    func test_conformsToViewModel() {
        XCTAssertTrue((sut as AnyObject) is ViewModel)
    }

    func test_givenViewDelegate_whenStarting_notifiesLoadingToViewDelegate() {
        givenViewDelegate()
        sut.start()
        XCTAssertEqual(viewDelegateMock.didStartLoadingCallCount, 1)
    }

    func test_givenCharacterFetcher_whenStrating_fetchesCharacter() {
        sut.start()
        XCTAssertEqual(characterFetcherMock.fetchCallCount, 1)
    }

    func test_givenSuccessfulCharacterFetcher_whenStartingCompletes_notifiesViewWithData() {
        givenSutWithSuccessfulFetcher()
        givenViewDelegate()
        sut.start()
        XCTAssertEqual(viewDelegateMock.didRetrieveCharacterCallCount, 1)
    }

    func test_givenViewDelegate_whenStartingCompletesSuccessfully_notifiesFinishLoadToViewDelegate() {
        givenSutWithSuccessfulFetcher()
        givenViewDelegate()
        sut.start()
        XCTAssertEqual(viewDelegateMock.didFinishLoadingCallCount, 1)
    }
}

private class CharacterDetailViewModelViewDelegateMock: CharacterDetailViewModelViewDelegate {

    var didStartLoadingCallCount = 0
    var didFinishLoadingCallCount = 0
    var didRetrieveCharacterCallCount = 0

    func viewModelDidStartLoading(_ viewModel: CharacterDetailViewModelProtocol) {
        didStartLoadingCallCount += 1
    }

    func viewModelDidFinishLoading(_ viewModel: CharacterDetailViewModelProtocol) {
        didFinishLoadingCallCount += 1
    }

    func viewModel(_ viewModel: CharacterDetailViewModelProtocol, didRetrieve characterDetail: CharacterDetailData) {
        didRetrieveCharacterCallCount += 1
    }
}

private class CharacterFetcherMock: FetchCharacterDetailUseCase {

    var fetchCallCount = 0

    func fetch(query: FetchCharacterDetailQuery, completion: @escaping (Result<PageInfo, Error>) -> Void) -> Cancellable? {
        fetchCallCount += 1
        return CancellableStub()
    }
}

private class CharacterFetcherSuccessfulStub: CharacterFetcherMock {

    static let resultsStub = [CharacterData.aginar]
    static let pageInfoStub = PageInfo.zeroWith(results: resultsStub)

    override func fetch(query: FetchCharacterDetailQuery, completion: @escaping (Result<PageInfo, Error>) -> Void) -> Cancellable? {
        let result = super.fetch(query: query, completion: completion)
        completion(.success(Self.pageInfoStub))
        return result
    }
}

private extension CharacterDetailViewModelTests {

    func givenViewDelegate() {
        sut.viewDelegate = viewDelegateMock
    }

    func givenSutWithSuccessfulFetcher() {
        characterFetcherMock = CharacterFetcherSuccessfulStub()
        sut = CharacterDetailViewModel(characterFetcher: characterFetcherMock)
    }
}
