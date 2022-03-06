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
    private var delegateMock: CollectionViewDelegateMock!

    override func setUp() {
        super.setUp()
        dataSourceMock = CollectionViewDataSourceMock()
        delegateMock = CollectionViewDelegateMock()
        presentationModelMock = CharacterDetailPresentationModelMock()
        sut = CharacterDetailViewController.instantiate(
            presentationModel: presentationModelMock,
            dataSource: dataSourceMock,
            collectionViewDelegate: delegateMock,
            layout: CharacterDetailLayout()
        )
    }

    override func tearDown() {
        sut = nil
        presentationModelMock = nil
        dataSourceMock = nil
        super.tearDown()
    }

    func test_whenViewDidLoad_callsPresentationModelStart() {
        assertPresentationModelStart(callCount: 0)
        sut.loadViewIfNeeded()
        assertPresentationModelStart(callCount: 1)
    }

    func test_whenViewDidDisappear_callsPresentationModelDispose() {
        assertPresentationModelDispose(callCount: 0)
        sut.viewDidDisappear(false)
        assertPresentationModelDispose(callCount: 1)
    }

    func test_whenViewDidLoad_dataSourceIsSet() {
        dataSourceMock.assertSetDataSource(callCount: 0)
        sut.loadViewIfNeeded()
        dataSourceMock.assertSetDataSource(callCount: 1)
    }
}

private class CharacterDetailPresentationModelMock: PresentationModelMock {}

private extension CharacterDetailViewControllerTests {
    func givenViewDidLoad() {
        sut.loadViewIfNeeded()
    }

    func assertPresentationModelStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(presentationModelMock.startCallCount, callCount, line: line)
    }

    func assertPresentationModelDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(presentationModelMock.disposeCallCount, callCount, line: line)
    }
}
