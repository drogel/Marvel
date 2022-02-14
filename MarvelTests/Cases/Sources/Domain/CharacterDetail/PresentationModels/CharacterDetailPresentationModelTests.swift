//
//  CharacterDetailPresentationModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

@testable import Marvel_Debug
import XCTest

class CharacterDetailPresentationModelTests: XCTestCase {
    private var sut: CharacterDetailPresentationModel!
    private var infoPresentationModelMock: CharacterDetailInfoPresentationModelMock!
    private var comicsPresentationModelMock: ComicsPresentationModelMock!
    private var viewDelegateMock: CharacterDetailViewDelegateMock!

    override func setUp() {
        super.setUp()
        infoPresentationModelMock = CharacterDetailInfoPresentationModelMock()
        comicsPresentationModelMock = ComicsPresentationModelMock()
        viewDelegateMock = CharacterDetailViewDelegateMock()
        sut = CharacterDetailPresentationModel(
            infoPresentationModel: infoPresentationModelMock,
            comicsPresentationModel: comicsPresentationModelMock
        )
    }

    override func tearDown() {
        sut = nil
        comicsPresentationModelMock = nil
        viewDelegateMock = nil
        infoPresentationModelMock = nil
        super.tearDown()
    }

    func test_conformsToPresentationModel() {
        XCTAssertTrue((sut as AnyObject) is PresentationModel)
    }

    func test_conformsToCharacterDetailPresentationModelProtocol() {
        XCTAssertTrue((sut as AnyObject) is CharacterDetailPresentationModelProtocol)
    }

    func test_conformsToSubPresentationModels() {
        XCTAssertTrue((sut as AnyObject) is CharacterInfoPresentationModelProtocol)
        XCTAssertTrue((sut as AnyObject) is ComicsPresentationModelProtocol)
    }

    func test_conformsToSubPresentationModelDelegates() {
        XCTAssertTrue((sut as AnyObject) is CharacterInfoPresentationModelViewDelegate)
        XCTAssertTrue((sut as AnyObject) is ComicsPresentationModelViewDelegate)
    }

    func test_whenStarting_callsStartOnAllSubPresentationModels() {
        assertInfoPresentationModelStart(callCount: 0)
        assertComicsPresentationModelStart(callCount: 0)
        sut.start()
        assertInfoPresentationModelStart(callCount: 1)
        assertComicsPresentationModelStart(callCount: 1)
    }

    func test_whenDisposing_callsDisposeOnAllSubPresentationModels() {
        assertInfoPresentationModelDispose(callCount: 0)
        assertComicsPresentationModelDispose(callCount: 0)
        sut.dispose()
        assertInfoPresentationModelDispose(callCount: 1)
        assertComicsPresentationModelDispose(callCount: 1)
    }

    func test_imageCellData_delegatesToInfoPresentationModel() {
        assertInfoPresentationModelImageCellData(callCount: 0)
        _ = sut.imageCellData
        assertInfoPresentationModelImageCellData(callCount: 1)
    }

    func test_infoCellData_delegatesToInfoPresentationModel() {
        assertInfoPresentationModelInfoCellData(callCount: 0)
        _ = sut.infoCellData
        assertInfoPresentationModelInfoCellData(callCount: 1)
    }

    func test_numberOfComics_delegatesToComicsPresentationModel() {
        assertComicsPresentationModelNumberOfComics(callCount: 0)
        _ = sut.numberOfComics
        assertComicsPresentationModelNumberOfComics(callCount: 1)
    }

    func test_comicCellData_delegatesToComicsPresentationModel() {
        assertComicsPresentationModelComicCellModel(callCount: 0)
        _ = sut.comicCellData(at: IndexPath(row: 0, section: 0))
        assertComicsPresentationModelComicCellModel(callCount: 1)
    }

    func test_givenViewDelegate_whenInfoStartsLoading_notifiesView() {
        givenViewDelegate()
        assertViewDelegateDidStartLoading(callCount: 0)
        sut.modelDidStartLoading(infoPresentationModelMock)
        assertViewDelegateDidStartLoading(callCount: 1)
    }

    func test_givenViewDelegate_whenInfoFinishesLoading_notifiesView() {
        givenViewDelegate()
        assertViewDelegateDidFinishLoading(callCount: 0)
        sut.modelDidFinishLoading(infoPresentationModelMock)
        assertViewDelegateDidFinishLoading(callCount: 1)
    }

    func test_givenViewDelegate_whenInfoRetrievesData_notifiesView() {
        givenViewDelegate()
        assertViewDelegateDidRetrieveCharacterInfo(callCount: 0)
        sut.modelDidRetrieveData(infoPresentationModelMock)
        assertViewDelegateDidRetrieveCharacterInfo(callCount: 1)
    }

    func test_givenViewDelegate_whenComicsAreRetrieved_notifiesView() {
        givenViewDelegate()
        assertViewDelegateDidRetrieveComics(callCount: 0)
        sut.modelDidRetrieveData(comicsPresentationModelMock)
        assertViewDelegateDidRetrieveComics(callCount: 1)
    }

    func test_givenViewDelegate_whenInfoFails_notifiesView() {
        givenViewDelegate()
        assertViewDelegateDidFail(callCount: 0)
        sut.model(infoPresentationModelMock, didFailWithError: "")
        assertViewDelegateDidFail(callCount: 1)
    }

    func test_givenViewDelegate_whenComicsFail_failsSilently() {
        givenViewDelegate()
        assertViewDelegateDidFail(callCount: 0)
        sut.modelDidFailRetrievingData(comicsPresentationModelMock)
        assertViewDelegateDidFail(callCount: 0)
    }

    func test_givenViewDelegate_whenComicsStartLoading_doesNothing() {
        givenViewDelegate()
        assertViewDelegateDidStartLoading(callCount: 0)
        sut.modelDidStartLoading(comicsPresentationModelMock)
        assertViewDelegateDidStartLoading(callCount: 0)
    }

    func test_givenViewDelegate_whenComicsFinishLoading_doesNothing() {
        givenViewDelegate()
        assertViewDelegateDidFinishLoading(callCount: 0)
        sut.modelDidFinishLoading(comicsPresentationModelMock)
        assertViewDelegateDidFinishLoading(callCount: 0)
    }

    func test_comicsSectionTitle_returnsComics() {
        XCTAssertEqual(sut.comicsSectionTitle, "comics".localized)
    }

    func test_whenAboutToDisplayAComicCell_delegatesToComicsPresentationModel() {
        assertComicsPresentationModelWillDisplayCell(callCount: 0)
        whenAboutToDisplayAComicCell()
        assertComicsPresentationModelWillDisplayCell(callCount: 1)
    }
}

private class CharacterDetailViewDelegateMock: CharacterDetailPresentationModelViewDelegate {
    var didStartLoadingCallCount = 0
    var didFinishLoadingCallCount = 0
    var didRetrieveCharacterInfoCallCount = 0
    var didRetrieveComicsCallCount = 0
    var didFailCallCount = 0

    func modelDidStartLoading(_: CharacterDetailPresentationModelProtocol) {
        didStartLoadingCallCount += 1
    }

    func modelDidFinishLoading(_: CharacterDetailPresentationModelProtocol) {
        didFinishLoadingCallCount += 1
    }

    func modelDidRetrieveCharacterInfo(_: CharacterDetailPresentationModelProtocol) {
        didRetrieveCharacterInfoCallCount += 1
    }

    func modelDidRetrieveComics(_: CharacterDetailPresentationModelProtocol) {
        didRetrieveComicsCallCount += 1
    }

    func model(_: CharacterDetailPresentationModelProtocol, didFailWithError _: String) {
        didFailCallCount += 1
    }
}

private extension CharacterDetailPresentationModelTests {
    func givenViewDelegate() {
        viewDelegateMock = CharacterDetailViewDelegateMock()
        sut.viewDelegate = viewDelegateMock
    }

    func whenAboutToDisplayAComicCell() {
        sut.willDisplayComicCell(at: IndexPath(row: 0, section: 0))
    }

    func assertInfoPresentationModelStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(infoPresentationModelMock.startCallCount, callCount, line: line)
    }

    func assertComicsPresentationModelStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsPresentationModelMock.startCallCount, callCount, line: line)
    }

    func assertInfoPresentationModelDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(infoPresentationModelMock.disposeCallCount, callCount, line: line)
    }

    func assertComicsPresentationModelDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsPresentationModelMock.disposeCallCount, callCount, line: line)
    }

    func assertInfoPresentationModelImageCellData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(infoPresentationModelMock.imageCellDataCallCount, callCount, line: line)
    }

    func assertInfoPresentationModelInfoCellData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(infoPresentationModelMock.infoCellDataCallCount, callCount, line: line)
    }

    func assertComicsPresentationModelNumberOfComics(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsPresentationModelMock.numberOfComicsCallCount, callCount, line: line)
    }

    func assertComicsPresentationModelComicCellModel(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsPresentationModelMock.comicsCellDataCallCount, callCount, line: line)
    }

    func assertComicsPresentationModelWillDisplayCell(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsPresentationModelMock.willDisplayComicCellCallCount, callCount, line: line)
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
