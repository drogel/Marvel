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
    private var presentationModelMock: CharacterDetailPresentationModelMock!
    private var dataSourceMock: CollectionViewDataSourceMock!
    private var dataSourceFactoryMock: CollectionViewDataSourceFactoryMock!

    override func setUp() {
        super.setUp()
        dataSourceFactoryMock = CollectionViewDataSourceFactoryMock()
        dataSourceMock = dataSourceFactoryMock.dataSourceMock
        presentationModelMock = CharacterDetailPresentationModelMock()
        sut = CharacterDetailViewController.instantiate(
            presentationModel: presentationModelMock,
            layout: CharacterDetailLayout(),
            dataSourceFactory: dataSourceFactoryMock
        )
    }

    override func tearDown() {
        sut = nil
        presentationModelMock = nil
        dataSourceMock = nil
        super.tearDown()
    }

    func test_whenViewDidLoad_callsPresentationModelStart() {
        presentationModelMock.assertStart(callCount: 0)
        sut.loadViewIfNeeded()
        presentationModelMock.assertStart(callCount: 1)
    }

    func test_whenViewDidDisappear_callsPresentationModelDispose() {
        presentationModelMock.assertDispose(callCount: 0)
        sut.viewDidDisappear(false)
        presentationModelMock.assertDispose(callCount: 1)
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
