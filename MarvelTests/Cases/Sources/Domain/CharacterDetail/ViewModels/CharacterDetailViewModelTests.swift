//
//  CharacterDetailViewModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

@testable import Marvel_Debug
import XCTest

class CharacterDetailViewModelTests: XCTestCase {
    private var sut: CharacterDetailViewModel!
    private var infoViewModelMock: CharacterDetailInfoViewModelMock!
    private var comicsViewModelMock: ComicsViewModelMock!
    private var viewDelegateMock: CharacterDetailViewModelViewDelegateMock!

    override func setUp() {
        super.setUp()
        infoViewModelMock = CharacterDetailInfoViewModelMock()
        comicsViewModelMock = ComicsViewModelMock()
        viewDelegateMock = CharacterDetailViewModelViewDelegateMock()
        sut = CharacterDetailViewModel(infoViewModel: infoViewModelMock, comicsViewModel: comicsViewModelMock)
    }

    override func tearDown() {
        sut = nil
        comicsViewModelMock = nil
        viewDelegateMock = nil
        infoViewModelMock = nil
        super.tearDown()
    }

    func test_conformsToViewModel() {
        XCTAssertTrue((sut as AnyObject) is ViewModel)
    }

    func test_conformsToCharacterDetailViewModelProtocol() {
        XCTAssertTrue((sut as AnyObject) is CharacterDetailViewModelProtocol)
    }

    func test_conformsToSubViewModels() {
        XCTAssertTrue((sut as AnyObject) is CharacterDetailInfoViewModelProtocol)
        XCTAssertTrue((sut as AnyObject) is ComicsViewModelProtocol)
    }

    func test_conformsToSubViewModelDelegates() {
        XCTAssertTrue((sut as AnyObject) is CharacterDetailInfoViewModelViewDelegate)
        XCTAssertTrue((sut as AnyObject) is ComicsViewModelViewDelegate)
    }

    func test_whenStarting_callsStartOnAllSubViewModels() {
        assertInfoViewModelStart(callCount: 0)
        assertComicsViewModelStart(callCount: 0)
        sut.start()
        assertInfoViewModelStart(callCount: 1)
        assertComicsViewModelStart(callCount: 1)
    }

    func test_whenDisposing_callsDisposeOnAllSubViewModels() {
        assertInfoViewModelDispose(callCount: 0)
        assertComicsViewModelDispose(callCount: 0)
        sut.dispose()
        assertInfoViewModelDispose(callCount: 1)
        assertComicsViewModelDispose(callCount: 1)
    }

    func test_imageCellData_delegatesToInfoViewModel() {
        assertInfoViewModelImageCellData(callCount: 0)
        _ = sut.imageCellData
        assertInfoViewModelImageCellData(callCount: 1)
    }

    func test_infoCellData_delegatesToInfoViewModel() {
        assertInfoViewModelInfoCellData(callCount: 0)
        _ = sut.infoCellData
        assertInfoViewModelInfoCellData(callCount: 1)
    }

    func test_numberOfComics_delegatesToComicsViewModel() {
        assertComicsViewModelNumberOfComics(callCount: 0)
        _ = sut.numberOfComics
        assertComicsViewModelNumberOfComics(callCount: 1)
    }

    func test_comicCellData_delegatesToComicsViewModel() {
        assertComicsViewModelComicCellData(callCount: 0)
        _ = sut.comicCellData(at: IndexPath(row: 0, section: 0))
        assertComicsViewModelComicCellData(callCount: 1)
    }

    func test_givenViewDelegate_whenInfoStartsLoading_notifiesView() {
        givenViewDelegate()
        assertViewDelegateDidStartLoading(callCount: 0)
        sut.viewModelDidStartLoading(infoViewModelMock)
        assertViewDelegateDidStartLoading(callCount: 1)
    }

    func test_givenViewDelegate_whenInfoFinishesLoading_notifiesView() {
        givenViewDelegate()
        assertViewDelegateDidFinishLoading(callCount: 0)
        sut.viewModelDidFinishLoading(infoViewModelMock)
        assertViewDelegateDidFinishLoading(callCount: 1)
    }

    func test_givenViewDelegate_whenInfoRetrievesData_notifiesView() {
        givenViewDelegate()
        assertViewDelegateDidRetrieveCharacterInfo(callCount: 0)
        sut.viewModelDidRetrieveData(infoViewModelMock)
        assertViewDelegateDidRetrieveCharacterInfo(callCount: 1)
    }

    func test_givenViewDelegate_whenComicsAreRetrieved_notifiesView() {
        givenViewDelegate()
        assertViewDelegateDidRetrieveComics(callCount: 0)
        sut.viewModelDidRetrieveData(comicsViewModelMock)
        assertViewDelegateDidRetrieveComics(callCount: 1)
    }

    func test_givenViewDelegate_whenInfoFails_notifiesView() {
        givenViewDelegate()
        assertViewDelegateDidFail(callCount: 0)
        sut.viewModel(infoViewModelMock, didFailWithError: "")
        assertViewDelegateDidFail(callCount: 1)
    }

    func test_givenViewDelegate_whenComicsFail_failsSilently() {
        givenViewDelegate()
        assertViewDelegateDidFail(callCount: 0)
        sut.viewModelDidFailRetrievingData(comicsViewModelMock)
        assertViewDelegateDidFail(callCount: 0)
    }

    func test_givenViewDelegate_whenComicsStartLoading_doesNothing() {
        givenViewDelegate()
        assertViewDelegateDidStartLoading(callCount: 0)
        sut.viewModelDidStartLoading(comicsViewModelMock)
        assertViewDelegateDidStartLoading(callCount: 0)
    }

    func test_givenViewDelegate_whenComicsFinishLoading_doesNothing() {
        givenViewDelegate()
        assertViewDelegateDidFinishLoading(callCount: 0)
        sut.viewModelDidFinishLoading(comicsViewModelMock)
        assertViewDelegateDidFinishLoading(callCount: 0)
    }

    func test_comicsSectionTitle_returnsComics() {
        XCTAssertEqual(sut.comicsSectionTitle, "comics".localized)
    }

    func test_whenAboutToDisplayAComicCell_delegatesToComicsViewModel() {
        assertComicsViewModelWillDisplayCell(callCount: 0)
        whenAboutToDisplayAComicCell()
        assertComicsViewModelWillDisplayCell(callCount: 1)
    }
}

private class CharacterDetailViewModelViewDelegateMock: CharacterDetailViewModelViewDelegate {
    var didStartLoadingCallCount = 0
    var didFinishLoadingCallCount = 0
    var didRetrieveCharacterInfoCallCount = 0
    var didRetrieveComicsCallCount = 0
    var didFailCallCount = 0

    func viewModelDidStartLoading(_: CharacterDetailViewModelProtocol) {
        didStartLoadingCallCount += 1
    }

    func viewModelDidFinishLoading(_: CharacterDetailViewModelProtocol) {
        didFinishLoadingCallCount += 1
    }

    func viewModelDidRetrieveCharacterInfo(_: CharacterDetailViewModelProtocol) {
        didRetrieveCharacterInfoCallCount += 1
    }

    func viewModelDidRetrieveComics(_: CharacterDetailViewModelProtocol) {
        didRetrieveComicsCallCount += 1
    }

    func viewModel(_: CharacterDetailViewModelProtocol, didFailWithError _: String) {
        didFailCallCount += 1
    }
}

private extension CharacterDetailViewModelTests {
    func givenViewDelegate() {
        viewDelegateMock = CharacterDetailViewModelViewDelegateMock()
        sut.viewDelegate = viewDelegateMock
    }

    func whenAboutToDisplayAComicCell() {
        sut.willDisplayComicCell(at: IndexPath(row: 0, section: 0))
    }

    func assertInfoViewModelStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(infoViewModelMock.startCallCount, callCount, line: line)
    }

    func assertComicsViewModelStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsViewModelMock.startCallCount, callCount, line: line)
    }

    func assertInfoViewModelDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(infoViewModelMock.disposeCallCount, callCount, line: line)
    }

    func assertComicsViewModelDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsViewModelMock.disposeCallCount, callCount, line: line)
    }

    func assertInfoViewModelImageCellData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(infoViewModelMock.imageCellDataCallCount, callCount, line: line)
    }

    func assertInfoViewModelInfoCellData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(infoViewModelMock.infoCellDataCallCount, callCount, line: line)
    }

    func assertComicsViewModelNumberOfComics(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsViewModelMock.numberOfComicsCallCount, callCount, line: line)
    }

    func assertComicsViewModelComicCellData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsViewModelMock.comicsCellDataCallCount, callCount, line: line)
    }

    func assertComicsViewModelWillDisplayCell(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsViewModelMock.willDisplayComicCellCallCount, callCount, line: line)
    }

    func assertViewDelegateDidStartLoading(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewDelegateMock.didStartLoadingCallCount, callCount, line: line)
    }

    func assertViewDelegateDidFinishLoading(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewDelegateMock.didFinishLoadingCallCount, callCount, line: line)
    }

    func assertViewDelegateDidRetrieveCharacterInfo(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewDelegateMock.didRetrieveCharacterInfoCallCount, callCount, line: line)
    }

    func assertViewDelegateDidRetrieveComics(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewDelegateMock.didRetrieveComicsCallCount, callCount, line: line)
    }

    func assertViewDelegateDidFail(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewDelegateMock.didFailCallCount, callCount, line: line)
    }
}
