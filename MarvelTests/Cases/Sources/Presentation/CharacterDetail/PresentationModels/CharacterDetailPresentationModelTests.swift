//
//  CharacterDetailPresentationModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Combine
@testable import Marvel_Debug
import XCTest

class CharacterDetailPresentationModelTests: XCTestCase {
    private var sut: CharacterDetailPresentationModel!
    private var infoPresentationModelMock: CharacterDetailInfoPresentationModelMock!
    private var comicsViewModelMock: ComicsViewModelMock!
    private var viewDelegateMock: CharacterDetailViewDelegateMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        infoPresentationModelMock = CharacterDetailInfoPresentationModelMock()
        comicsViewModelMock = ComicsViewModelMock()
        viewDelegateMock = CharacterDetailViewDelegateMock()
        sut = CharacterDetailPresentationModel(
            infoPresentationModel: infoPresentationModelMock,
            comicsViewModel: comicsViewModelMock
        )
    }

    override func tearDown() {
        sut = nil
        cancellables = nil
        comicsViewModelMock = nil
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

    func test_whenStarting_callsStartOnAllSubPresentationModels() {
        assertInfoPresentationModelStart(callCount: 0)
        assertComicsViewModelStart(callCount: 0)
        sut.start()
        assertInfoPresentationModelStart(callCount: 1)
        assertComicsViewModelStart(callCount: 1)
    }

    func test_whenDisposing_callsDisposeOnAllSubPresentationModels() {
        assertInfoPresentationModelDispose(callCount: 0)
        assertComicsViewModelDispose(callCount: 0)
        sut.dispose()
        assertInfoPresentationModelDispose(callCount: 1)
        assertComicsViewModelDispose(callCount: 1)
    }

    func test_whenAboutToDisplayAComicCell_delegatesToComicsViewModel() {
        assertComicsViewModelWillDisplayCell(callCount: 0)
        whenAboutToDisplayAComicCell()
        assertComicsViewModelWillDisplayCell(callCount: 1)
    }

    func test_whenReceivingDetailStateValues_delegatesToInfoAndComicsPublishers() {
        assertInfoPresentationModelInfoStatePublisher(callCount: 0)
        assertComicsViewModelComicCellModelsPublisher(callCount: 0)
        sut.detailStatePublisher.sink(receiveValue: { _ in }).store(in: &cancellables)
        assertInfoPresentationModelInfoStatePublisher(callCount: 1)
        assertComicsViewModelComicCellModelsPublisher(callCount: 1)
    }

    func test_whenReceivingDetailStateValues_combinesInfoAndComicsPublishers() {
        let receivedValueExpectation = expectation(description: "Received a detail state value")
        let expectedDetailModel = CharacterDetailModel(
            info: CharacterDetailInfoPresentationModelMock.emitedInfoViewModelState,
            comics: ComicsViewModelMock.emittedComicCellModels
        )
        let expectedState = CharacterDetailViewModelState.success(expectedDetailModel)
        sut.detailStatePublisher
            .assertOutput(matches: expectedState, expectation: receivedValueExpectation)
            .store(in: &cancellables)
        wait(for: [receivedValueExpectation], timeout: 0.1)
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

    func assertComicsViewModelStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsViewModelMock.startCallCount, callCount, line: line)
    }

    func assertInfoPresentationModelDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(infoPresentationModelMock.disposeCallCount, callCount, line: line)
    }

    func assertComicsViewModelDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsViewModelMock.disposeCallCount, callCount, line: line)
    }

    func assertInfoPresentationModelInfoStatePublisher(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(infoPresentationModelMock.infoStatePublisherCallCount, callCount, line: line)
    }

    func assertComicsViewModelComicCellModelsPublisher(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsViewModelMock.comicCellModelsPublisherCallCount, callCount, line: line)
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
