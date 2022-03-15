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
    private var dataSourceFactoryMock: CollectionViewDataSourceFactoryMock!
    private var dataSourceMock: CollectionViewDataSourceMock!

    override func setUp() {
        super.setUp()
        viewModelMock = CharactersViewModelMock()
        dataSourceFactoryMock = CollectionViewDataSourceFactoryMock()
        dataSourceMock = dataSourceFactoryMock.dataSourceMock
        sut = CharactersViewController.instantiate(
            viewModel: viewModelMock,
            layout: CharactersLayout(),
            dataSourceFactory: dataSourceFactoryMock
        )
    }

    override func tearDown() {
        sut = nil
        dataSourceFactoryMock = nil
        dataSourceMock = nil
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

    func test_whenSelectingACell_notifiesViewModel() {
        assertViewModelSelect(callCount: 0)
        sut.collectionView(collectionViewStub, didSelectItemAt: indexPathStub)
        assertViewModelSelect(callCount: 1)
    }

    func test_whenViewDidLoad_callsDataSourceFactoryCreate() {
        dataSourceFactoryMock.assertCreate(callCount: 0)
        sut.loadViewIfNeeded()
        dataSourceFactoryMock.assertCreate(callCount: 1)
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
