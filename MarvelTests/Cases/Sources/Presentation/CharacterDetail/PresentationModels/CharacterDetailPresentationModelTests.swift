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
    private var infoViewModelMock: CharacterDetailInfoViewModelMock!
    private var comicsViewModelMock: ComicsViewModelMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        infoViewModelMock = CharacterDetailInfoViewModelMock()
        comicsViewModelMock = ComicsViewModelMock()
        sut = CharacterDetailPresentationModel(
            infoViewModel: infoViewModelMock,
            comicsViewModel: comicsViewModelMock
        )
    }

    override func tearDown() {
        sut = nil
        cancellables = nil
        comicsViewModelMock = nil
        infoViewModelMock = nil
        super.tearDown()
    }

    func test_conformsToPresentationModel() {
        XCTAssertTrue((sut as AnyObject) is PresentationModel)
    }

    func test_conformsToCharacterDetailPresentationModelProtocol() {
        XCTAssertTrue((sut as AnyObject) is CharacterDetailPresentationModelProtocol)
    }

    func test_whenStarting_callsStartOnAllSubPresentationModels() {
        assertInfoViewModelStart(callCount: 0)
        assertComicsViewModelStart(callCount: 0)
        sut.start()
        assertInfoViewModelStart(callCount: 1)
        assertComicsViewModelStart(callCount: 1)
    }

    func test_whenDisposing_callsDisposeOnAllSubPresentationModels() {
        assertInfoViewModelDispose(callCount: 0)
        assertComicsViewModelDispose(callCount: 0)
        sut.dispose()
        assertInfoViewModelDispose(callCount: 1)
        assertComicsViewModelDispose(callCount: 1)
    }

    func test_whenAboutToDisplayAComicCell_delegatesToComicsViewModel() {
        assertComicsViewModelWillDisplayCell(callCount: 0)
        whenAboutToDisplayAComicCell()
        assertComicsViewModelWillDisplayCell(callCount: 1)
    }

    func test_whenReceivingDetailStateValues_delegatesToInfoAndComicsPublishers() {
        assertInfoViewModelInfoStatePublisher(callCount: 0)
        assertComicsViewModelComicCellModelsPublisher(callCount: 0)
        sut.detailStatePublisher.sink(receiveValue: { _ in }).store(in: &cancellables)
        assertInfoViewModelInfoStatePublisher(callCount: 1)
        assertComicsViewModelComicCellModelsPublisher(callCount: 1)
    }

    func test_whenReceivingDetailStateValues_combinesInfoAndComicsPublishers() {
        let receivedValueExpectation = expectation(description: "Received a detail state value")
        let expectedDetailModel = CharacterDetailModel(
            info: CharacterDetailInfoViewModelMock.emitedInfoViewModelState,
            comics: ComicsViewModelMock.emittedComicCellModels
        )
        let expectedState = CharacterDetailViewModelState.success(expectedDetailModel)
        sut.detailStatePublisher
            .assertOutput(matches: expectedState, expectation: receivedValueExpectation)
            .store(in: &cancellables)
        wait(for: [receivedValueExpectation], timeout: 0.1)
    }
}

private extension CharacterDetailPresentationModelTests {
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

    func assertInfoViewModelInfoStatePublisher(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(infoViewModelMock.infoStatePublisherCallCount, callCount, line: line)
    }

    func assertComicsViewModelComicCellModelsPublisher(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsViewModelMock.comicCellModelsPublisherCallCount, callCount, line: line)
    }

    func assertComicsViewModelWillDisplayCell(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsViewModelMock.willDisplayComicCellCallCount, callCount, line: line)
    }
}
