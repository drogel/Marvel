//
//  CharactersViewControllerTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 2/2/22.
//

@testable import Marvel_Debug
import XCTest

class CharactersViewControllerTests: XCTestCase {
    private var sut: CharactersViewController!
    private var viewModelMock: CharactersViewModelMock!

    override func setUp() {
        super.setUp()
        viewModelMock = CharactersViewModelMock()
        sut = CharactersViewController.instantiate(viewModel: viewModelMock, layout: CharactersLayout())
    }

    override func tearDown() {
        sut = nil
        viewModelMock = nil
        super.tearDown()
    }

    func test_whenViewDidAppear_callsViewModelStart() {
        assertViewModelStart(callCount: 0)
        sut.viewDidAppear(false)
        assertViewModelStart(callCount: 1)
    }

    func test_whenViewDidDisappear_callsViewModelDispose() {
        assertViewModelDispose(callCount: 0)
        sut.viewDidDisappear(false)
        assertViewModelDispose(callCount: 1)
    }

    func test_numberOfSections_returnsOneSection() {
        XCTAssertEqual(sut.numberOfSections(in: collectionViewStub), 1)
    }

    func test_numberOfItems_returnsViewModelNumberOfItems() {
        XCTAssertEqual(
            sut.collectionView(collectionViewStub, numberOfItemsInSection: 0),
            viewModelMock.numberOfItems
        )
    }

    func test_whenDequeueingCells_retrievesViewModelCellData() {
        assertViewModelCellData(callCount: 0)
        _ = sut.collectionView(collectionViewStub, cellForItemAt: indexPathStub)
        assertViewModelCellData(callCount: 1)
    }

    func test_whenSelectingACell_notifiesViewModel() {
        assertViewModelSelect(callCount: 0)
        sut.collectionView(collectionViewStub, didSelectItemAt: indexPathStub)
        assertViewModelSelect(callCount: 1)
    }

    func test_whenAboutToDisplayACell_notifiesViewModel() {
        assertViewModelWillDisplayCell(callCount: 0)
        sut.collectionView(collectionViewStub, willDisplay: UICollectionViewCell(), forItemAt: indexPathStub)
        assertViewModelWillDisplayCell(callCount: 1)
    }
}

private class CharactersViewModelMock: CharactersViewModelProtocol {
    var numberOfItemsCallCount = 0
    var willDisplayCellCallCount = 0
    var selectCallCount = 0
    var cellDataCallCount = 0
    var startCallCount = 0
    var disposeCallCount = 0

    var numberOfItems: Int {
        numberOfItemsCallCount += 1
        return 0
    }

    func willDisplayCell(at _: IndexPath) {
        willDisplayCellCallCount += 1
    }

    func select(at _: IndexPath) {
        selectCallCount += 1
    }

    func cellData(at _: IndexPath) -> CharacterCellData? {
        cellDataCallCount += 1
        return nil
    }

    func start() {
        startCallCount += 1
    }

    func dispose() {
        disposeCallCount += 1
    }
}

private extension CharactersViewControllerTests {
    var collectionViewStub: UICollectionView {
        UICollectionViewStub()
    }

    var indexPathStub: IndexPath {
        IndexPath(row: 0, section: 0)
    }

    func assertViewModelStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.startCallCount, callCount, line: line)
    }

    func assertViewModelDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.disposeCallCount, callCount, line: line)
    }

    func assertViewModelCellData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.cellDataCallCount, callCount, line: line)
    }

    func assertViewModelSelect(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.selectCallCount, callCount, line: line)
    }

    func assertViewModelWillDisplayCell(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.willDisplayCellCallCount, callCount, line: line)
    }
}
