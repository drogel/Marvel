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
    private var presentationModelMock: CharactersPresentationModelMock!

    override func setUp() {
        super.setUp()
        presentationModelMock = CharactersPresentationModelMock()
        sut = CharactersViewController.instantiate(presentationModel: presentationModelMock, layout: CharactersLayout())
    }

    override func tearDown() {
        sut = nil
        presentationModelMock = nil
        super.tearDown()
    }

    func test_whenViewDidAppear_callsPresentationModelStart() {
        assertPresentationModelStart(callCount: 0)
        sut.viewDidAppear(false)
        assertPresentationModelStart(callCount: 1)
    }

    func test_whenViewDidDisappear_callsPresentationModelDispose() {
        assertPresentationModelDispose(callCount: 0)
        sut.viewDidDisappear(false)
        assertPresentationModelDispose(callCount: 1)
    }

    func test_numberOfSections_returnsOneSection() {
        XCTAssertEqual(sut.numberOfSections(in: collectionViewStub), 1)
    }

    func test_numberOfItems_returnsPresentationModelNumberOfItems() {
        XCTAssertEqual(
            sut.collectionView(collectionViewStub, numberOfItemsInSection: 0),
            presentationModelMock.numberOfItems
        )
    }

    func test_whenDequeueingCells_retrievesPresentationModelCellData() {
        assertPresentationModelCellData(callCount: 0)
        _ = sut.collectionView(collectionViewStub, cellForItemAt: indexPathStub)
        assertPresentationModelCellData(callCount: 1)
    }

    func test_whenSelectingACell_notifiesPresentationModel() {
        assertPresentationModelSelect(callCount: 0)
        sut.collectionView(collectionViewStub, didSelectItemAt: indexPathStub)
        assertPresentationModelSelect(callCount: 1)
    }
}

private class CharactersPresentationModelMock: CharactersPresentationModelProtocol {
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

    func cellData(at _: IndexPath) -> CharacterCellModel? {
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

    func assertPresentationModelStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(presentationModelMock.startCallCount, callCount, line: line)
    }

    func assertPresentationModelDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(presentationModelMock.disposeCallCount, callCount, line: line)
    }

    func assertPresentationModelCellData(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(presentationModelMock.cellDataCallCount, callCount, line: line)
    }

    func assertPresentationModelSelect(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(presentationModelMock.selectCallCount, callCount, line: line)
    }

    func assertPresentationModelWillDisplayCell(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(presentationModelMock.willDisplayCellCallCount, callCount, line: line)
    }
}
