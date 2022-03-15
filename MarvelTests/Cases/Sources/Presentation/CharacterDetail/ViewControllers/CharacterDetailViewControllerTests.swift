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
    private var dataSourceFactoryMock: CollectionViewDataSourceFactoryMock!

    override func setUp() {
        super.setUp()
        dataSourceFactoryMock = CollectionViewDataSourceFactoryMock()
        dataSourceMock = dataSourceFactoryMock.dataSourceMock
        viewModelMock = CharacterDetailViewModelMock()
        sut = CharacterDetailViewController.instantiate(
            viewModel: viewModelMock,
            layout: CharacterDetailLayout(),
            dataSourceFactory: dataSourceFactoryMock
        )
    }

    override func tearDown() {
        sut = nil
        viewModelMock = nil
        dataSourceMock = nil
        super.tearDown()
    }

    func test_whenViewDidLoad_callsViewModelStart() {
        viewModelMock.assertStart(callCount: 0)
        sut.loadViewIfNeeded()
        viewModelMock.assertStart(callCount: 1)
    }

    func test_whenViewDidDisappear_callsViewModelDispose() {
        viewModelMock.assertDispose(callCount: 0)
        sut.viewDidDisappear(false)
        viewModelMock.assertDispose(callCount: 1)
    }

    func test_whenViewDidLoad_dataSourceIsSet() {
        dataSourceMock.assertSetDataSource(callCount: 0)
        sut.loadViewIfNeeded()
        dataSourceMock.assertSetDataSource(callCount: 1)
    }
}

private extension CharacterDetailViewControllerTests {
    func givenViewDidLoad() {
        sut.loadViewIfNeeded()
    }
}
