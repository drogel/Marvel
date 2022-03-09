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
    private var dataSourceFactoryMock: CollectionViewDataSourceFactoryMock!
    private var dataSourceMock: CollectionViewDataSourceMock!

    override func setUp() {
        super.setUp()
        presentationModelMock = CharactersPresentationModelMock()
        dataSourceFactoryMock = CollectionViewDataSourceFactoryMock()
        dataSourceMock = dataSourceFactoryMock.dataSourceMock
        sut = CharactersViewController.instantiate(
            presentationModel: presentationModelMock,
            layout: CharactersLayout(),
            dataSourceFactory: dataSourceFactoryMock
        )
    }

    override func tearDown() {
        sut = nil
        dataSourceFactoryMock = nil
        dataSourceMock = nil
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

    func test_whenSelectingACell_notifiesPresentationModel() {
        assertPresentationModelSelect(callCount: 0)
        sut.collectionView(collectionViewStub, didSelectItemAt: indexPathStub)
        assertPresentationModelSelect(callCount: 1)
    }

    func test_whenViewDidLoad_callsDataSourceFactoryCreate() {
        dataSourceFactoryMock.assertCreate(callCount: 0)
        sut.loadViewIfNeeded()
        dataSourceFactoryMock.assertCreate(callCount: 1)
    }

    func test_givenViewDidLoad_whenModelUpdatedItems_appliesSnapshot() {
        givenViewDidLoad()
        dataSourceMock.assertApplySnapshot(callCount: 0)
        sut.modelDidUpdateItems(presentationModelMock)
        dataSourceMock.assertApplySnapshot(callCount: 1)
    }

    func test_whenViewDidLoad_dataSourceIsSet() {
        dataSourceMock.assertSetDataSource(callCount: 0)
        sut.loadViewIfNeeded()
        dataSourceMock.assertSetDataSource(callCount: 1)
    }
}

private extension CharactersViewControllerTests {
    var collectionViewStub: UICollectionView {
        UICollectionViewStub()
    }

    var indexPathStub: IndexPath {
        IndexPath(row: 0, section: 0)
    }

    func givenViewDidLoad() {
        sut.loadViewIfNeeded()
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
