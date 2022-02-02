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
}

private class CharacterDetailViewModelMock: CharacterDetailViewModelProtocol {
    var startCallCount = 0
    var disposeCallCount = 0

    func start() {
        startCallCount += 1
    }

    func dispose() {
        disposeCallCount += 1
    }
}

private extension CharacterDetailViewControllerTests {
    func assertViewModelStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.startCallCount, callCount, line: line)
    }

    func assertViewModelDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewModelMock.disposeCallCount, callCount, line: line)
    }
}
