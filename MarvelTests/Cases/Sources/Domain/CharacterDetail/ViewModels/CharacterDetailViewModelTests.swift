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

    override func setUp() {
        super.setUp()
        infoViewModelMock = CharacterDetailInfoViewModelMock()
        comicsViewModelMock = ComicsViewModelMock()
        sut = CharacterDetailViewModel(infoViewModel: infoViewModelMock, comicsViewModel: comicsViewModelMock)
    }

    override func tearDown() {
        sut = nil
        comicsViewModelMock = nil
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
}

private extension CharacterDetailViewModelTests {
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
}
