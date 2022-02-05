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
    private var dataSourceMock: CollectionViewDataSourceMock!

    override func setUp() {
        super.setUp()
        dataSourceMock = CollectionViewDataSourceMock()
        viewModelMock = CharacterDetailViewModelMock()
        sut = CharacterDetailViewController.instantiate(
            viewModel: viewModelMock,
            dataSource: dataSourceMock,
            layout: CharacterDetailLayout()
        )
    }

    override func tearDown() {
        sut = nil
        viewModelMock = nil
        dataSourceMock = nil
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

    func test_whenViewDidLoad_registersSubviewsInCollectionView() {
        assertDataSourceRegisterSubviews(callCount: 0)
        sut.loadViewIfNeeded()
        assertDataSourceRegisterSubviews(callCount: 1)
    }
}

private class CharacterDetailViewModelMock: ViewModelMock {}

private extension CharacterDetailViewControllerTests {
    func assertViewModelStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.startCallCount, callCount, line: line)
    }

    func assertViewModelDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.disposeCallCount, callCount, line: line)
    }

    func assertDataSourceRegisterSubviews(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(dataSourceMock.registerSubviewsCallCount, callCount, line: line)
    }
}
