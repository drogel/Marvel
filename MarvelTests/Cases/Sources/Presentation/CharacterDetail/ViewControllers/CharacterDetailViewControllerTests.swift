//
//  CharacterDetailViewControllerTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 2/2/22.
//

@testable import Marvel_Debug
import XCTest

class CharacterDetailViewControllerTests: XCTestCase {
    private var sut: CharacterDetailViewController!
    private var viewModelMock: CharacterDetailViewModelMock!

    override func setUp() {
        super.setUp()
        viewModelMock = CharacterDetailViewModelMock()
        sut = CharacterDetailViewController.instantiate(viewModel: viewModelMock)
    }

    override func tearDown() {
        sut = nil
        viewModelMock = nil
        super.tearDown()
    }

    func test_whenViewDidLoad_callsViewModelStart() {
        assertViewModelStart(callCount: 0)
        sut.loadViewIfNeeded()
        assertViewModelStart(callCount: 1)
    }

    func test_whenViewDidDisappear_callsViewModelDispose() {
        assertViewModelDispose(callCount: 0)
        sut.viewDidDisappear(false)
        assertViewModelDispose(callCount: 1)
    }

    func test_givenViewDidLoad_whenRetrievingCellAtFirstSection_callsViewModelImageCellData() {
        sut.loadViewIfNeeded()
        assertViewModelImageCellData(callCount: 0)
        _ = sut.collectionView(collectionViewStub, cellForItemAt: IndexPath(row: 0, section: 0))
        assertViewModelImageCellData(callCount: 1)
    }

    func test_givenViewDidLoad_whenRetrievingCellAtSecondSection_callsViewModelInfoCellData() {
        sut.loadViewIfNeeded()
        assertViewModelInfoCellData(callCount: 0)
        _ = sut.collectionView(collectionViewStub, cellForItemAt: IndexPath(row: 0, section: 1))
        assertViewModelInfoCellData(callCount: 1)
    }

    func test_collectionViewHasTwoSections() {
        XCTAssertEqual(sut.numberOfSections(in: collectionViewStub), 2)
    }

    func test_collectionViewHasOneCellPerSection() {
        XCTAssertEqual(sut.collectionView(collectionViewStub, numberOfItemsInSection: 0), 1)
        XCTAssertEqual(sut.collectionView(collectionViewStub, numberOfItemsInSection: 1), 1)
    }
}

private class CharacterDetailViewModelMock: CharacterDetailViewModelProtocol {
    var startCallCount = 0
    var disposeCallCount = 0
    var imageCellDataCallCount = 0
    var infoCellDataCallCount = 0

    var imageCellData: CharacterImageData? {
        imageCellDataCallCount += 1
        return nil
    }

    var infoCellData: CharacterInfoData? {
        infoCellDataCallCount += 1
        return nil
    }

    func start() {
        startCallCount += 1
    }

    func dispose() {
        disposeCallCount += 1
    }
}

private extension CharacterDetailViewControllerTests {
    var collectionViewStub: UICollectionView {
        UICollectionViewStub()
    }

    func assertViewModelStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.startCallCount, callCount, line: line)
    }

    func assertViewModelDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.disposeCallCount, callCount, line: line)
    }

    func assertViewModelImageCellData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.imageCellDataCallCount, callCount, line: line)
    }

    func assertViewModelInfoCellData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.infoCellDataCallCount, callCount, line: line)
    }
}
