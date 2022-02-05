//
//  CharacterDetailViewModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

@testable import Marvel_Debug
import XCTest

class CharacterDetailViewModelTests: XCTestCase {
    private var sut: CharacterDetailViewModel!
    private var infoViewModelMock: CharacterDetailInfoViewModelMock!
    private var comicsViewModelMock: ComicsViewModelMock!

    override func setUp() {
        super.setUp()
        infoViewModelMock = CharacterDetailInfoViewModelMock()
        comicsViewModelMock = ComicsViewModelMock()
        sut = CharacterDetailViewModel(infoViewModel: infoViewModelMock, comicsViewModel: comicsViewModelMock)
    }

    override func tearDown() {
        sut = nil
        comicsViewModelMock = nil
        infoViewModelMock = nil
        super.tearDown()
    }

    func test_conformsToViewModel() {
        XCTAssertTrue((sut as AnyObject) is ViewModel)
    }

    func test_conformsToCharacterDetailViewModelProtocol() {
        XCTAssertTrue((sut as AnyObject) is CharacterDetailViewModelProtocol)
    }

    func test_whenStarting_callsStartOnAllSubViewModels() {
        assertInfoViewModelStart(callCount: 0)
        assertComicsViewModelStart(callCount: 0)
        sut.start()
        assertInfoViewModelStart(callCount: 1)
        assertComicsViewModelStart(callCount: 1)
    }

    func test_whenDisposing_callsDisposeOnAllSubViewModels() {
        assertInfoViewModelDispose(callCount: 0)
        assertComicsViewModelDispose(callCount: 0)
        sut.dispose()
        assertInfoViewModelDispose(callCount: 1)
        assertComicsViewModelDispose(callCount: 1)
    }
}

private extension CharacterDetailViewModelTests {
    func assertInfoViewModelStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(infoViewModelMock.startCallCount, callCount, line: line)
    }

    func assertComicsViewModelStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsViewModelMock.startCallCount, callCount, line: line)
    }

    func assertInfoViewModelDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(infoViewModelMock.disposeCallCount, callCount, line: line)
    }

    func assertComicsViewModelDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(comicsViewModelMock.disposeCallCount, callCount, line: line)
    }
}
