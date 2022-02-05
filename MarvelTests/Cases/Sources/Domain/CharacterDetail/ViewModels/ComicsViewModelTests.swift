//
//  ComicsViewModelTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import XCTest
@testable import Marvel_Debug

class ComicsViewModelTests: XCTestCase {

    private var sut: ComicsViewModel!
    private var viewDelegate: ComicsViewModelViewDelegateMock!

    override func setUp() {
        super.setUp()
        sut = ComicsViewModel()
    }

    override func tearDown() {
        sut = nil
        viewDelegate = nil
        super.tearDown()
    }

    func test_conformsToComicsViewModelProtocol() {
        XCTAssertTrue((sut as AnyObject) is ComicsViewModelProtocol)
    }

    func test_conformsToViewModel() {
        XCTAssertTrue((sut as AnyObject) is ViewModel)
    }

    func test_givenViewDelegate_whenStarting_notifiesLoading() {
        givenViewDelegate()
        assertViewDelegateDidStartLoading(callCount: 0)
        sut.start()
        assertViewDelegateDidStartLoading(callCount: 1)
    }
}

private class ComicsViewModelViewDelegateMock: ComicsViewModelViewDelegate {

    var didStartLoadingCallCount = 0

    func viewModelDidStartLoading(_ viewModel: ComicsViewModelProtocol) {
        didStartLoadingCallCount += 1
    }
}

private extension ComicsViewModelTests {

    func givenViewDelegate() {
        viewDelegate = ComicsViewModelViewDelegateMock()
        sut.viewDelegate = viewDelegate
    }

    func assertViewDelegateDidStartLoading(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(viewDelegate.didStartLoadingCallCount, callCount, line: line)
    }
}
