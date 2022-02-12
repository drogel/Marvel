//
//  CharacterInfoPresentationModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

@testable import Marvel_Debug
import XCTest

class CharacterInfoPresentationModelTests: XCTestCase {
    private var sut: CharacterInfoPresentationModel!
    private var characterFetcherMock: CharacterFetcherMock!
    private var characterIDStub: Int!
    private var viewDelegateMock: CharacterInfoViewDelegateMock!
    private var imageURLBuilderMock: ImageURLBuilderMock!

    override func setUp() {
        super.setUp()
        characterFetcherMock = CharacterFetcherMock()
        characterIDStub = 123_456
        viewDelegateMock = CharacterInfoViewDelegateMock()
        imageURLBuilderMock = ImageURLBuilderMock()
        givenSut(with: characterFetcherMock)
    }

    override func tearDown() {
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

    func test_infoCellDataIsNilInitially() {
        assertCellDataIsNil()
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

    func test_givenSuccessfulCharacterFetcher_whenStartingCompletes_infoCellDataIsNotNil() {
        givenStartCompletedSuccessfully()
        XCTAssertNotNil(sut.infoCellData)
    }

    func test_givenSuccessfulCharacterFetcher_whenStartingCompletes_imageCellDataIsNotNil() {
        givenStartCompletedSuccessfully()
        XCTAssertNotNil(sut.imageCellData)
    }

    func test_givenStartFailed_allCellDataIsNil() {
        givenStartFailed()
        assertCellDataIsNil()
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
    var cancellable: CancellableMock?

    func fetch(
        query: FetchCharacterDetailQuery,
        completion _: @escaping (FetchCharacterDetailResult) -> Void
    ) -> Cancellable? {
        fetchCallCount += 1
        fetchCallCountsForID[query.characterID] = fetchCallCountsForID[query.characterID] ?? 0 + 1
        cancellable = CancellableMock()
        return cancellable
    }

    func fetchCallCount(withID identifier: Int) -> Int {
        guard let fetchCallCountForID = fetchCallCountsForID[identifier] else { return 0 }
        return fetchCallCountForID
    }
}

private class CharacterFetcherSuccessfulStub: CharacterFetcherMock {
    static let resultsStub = [CharacterData.aginar]
    static let pageInfoStub = PageInfo<CharacterData>.zeroWith(results: resultsStub)

    override func fetch(
        query: FetchCharacterDetailQuery,
        completion: @escaping (FetchCharacterDetailResult) -> Void
    ) -> Cancellable? {
        let result = super.fetch(query: query, completion: completion)
        completion(.success(Self.pageInfoStub))
        return result
    }
}

private class CharacterFetcherFailingStub: CharacterFetcherMock {
    override func fetch(
        query: FetchCharacterDetailQuery,
        completion: @escaping (FetchCharacterDetailResult) -> Void
    ) -> Cancellable? {
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

    func retrieveFetcherMockCancellableMock() -> CancellableMock {
        try! XCTUnwrap(characterFetcherMock.cancellable)
    }

    func assertCancelledRequests(line _: UInt = #line) {
        let cancellableMock = retrieveFetcherMockCancellableMock()
        XCTAssertEqual(cancellableMock.didCancelCallCount, 1)
    }

    func assertCellDataIsNil(line _: UInt = #line) {
        XCTAssertNil(sut.imageCellData)
        XCTAssertNil(sut.infoCellData)
    }
}
