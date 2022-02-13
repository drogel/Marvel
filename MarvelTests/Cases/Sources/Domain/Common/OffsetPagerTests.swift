//
//  OffsetPagerTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 8/2/22.
//

@testable import Marvel_Debug
import XCTest

class OffsetPagerTests: XCTestCase {
    private var sut: OffsetPager!

    override func setUp() {
        super.setUp()
        sut = OffsetPager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_conformsToPager() {
        XCTAssertTrue((sut as AnyObject) is Pager)
    }

    func test_givenOffsetDoesNotReachTotal_isThereMoreContent_returnsTrue() {
        givenSutWithFirstPageOfTwoTotalPages()
        XCTAssertTrue(sut.isThereMoreContent(at: 0))
        XCTAssertTrue(sut.isThereMoreContent(at: 20))
        XCTAssertTrue(sut.isThereMoreContent(at: 21))
        XCTAssertTrue(sut.isThereMoreContent(at: 19))
    }

    func test_givenOffsetDidReachTotal_isThereMoreContent_returnsFalse() {
        givenSutWithFirstPageOfTwoTotalPages()
        XCTAssertFalse(sut.isThereMoreContent(at: 40))
        XCTAssertFalse(sut.isThereMoreContent(at: 39))
        XCTAssertFalse(sut.isThereMoreContent(at: 41))
        XCTAssertFalse(sut.isThereMoreContent(at: 100))
    }

    func test_givenNoPage_isThereMoreContent_returnsFalse() {
        XCTAssertFalse(sut.isThereMoreContent(at: 0))
    }

    func test_givenOffsetDoesNotReachLimit_isAtEndOfCurrentPage_returnsFalse() {
        givenSutWithFirstPageOfTwoTotalPages()
        XCTAssertFalse(sut.isAtEndOfCurrentPage(0))
        XCTAssertFalse(sut.isAtEndOfCurrentPage(18))
    }

    func test_givenOffsetDidReachLimit_isAtEndOfCurrentPage_returnsTrue() {
        givenSutWithFirstPageOfTwoTotalPages()
        XCTAssertTrue(sut.isAtEndOfCurrentPage(19))
    }

    func test_givenNoPage_isAtEndOfCurrentPage_returnsFalse() {
        XCTAssertFalse(sut.isAtEndOfCurrentPage(0))
    }

    func test_givenOffsetDoesNotReachLimit_isAtEndOfCurrentPageWithMoreContent_returnsFalse() {
        givenSutWithFirstPageOfTwoTotalPages()
        XCTAssertFalse(sut.isAtEndOfCurrentPageWithMoreContent(0))
        XCTAssertFalse(sut.isAtEndOfCurrentPageWithMoreContent(18))
    }

    func test_givenOffsetDidReachLimit_isAtEndOfCurrentPageWithMoreContent_returnsTrue() {
        givenSutWithFirstPageOfTwoTotalPages()
        XCTAssertTrue(sut.isAtEndOfCurrentPageWithMoreContent(19))
    }

    func test_givenNoPage_isAtEndOfCurrentPageWithMoreContent_returnsFalse() {
        XCTAssertFalse(sut.isAtEndOfCurrentPageWithMoreContent(0))
    }

    func test_givenOffsetDidReachInLastPage_isAtEndOfCurrentPageWithMoreContent_returnsFalse() {
        givenSutWithSecondPageOfTwoTotalPages()
        XCTAssertFalse(sut.isAtEndOfCurrentPageWithMoreContent(39))
        XCTAssertFalse(sut.isAtEndOfCurrentPageWithMoreContent(40))
        XCTAssertFalse(sut.isAtEndOfCurrentPageWithMoreContent(50))
    }
}

private extension OffsetPagerTests {
    func givenSutWithFirstPageOfTwoTotalPages() {
        sut.update(currentPage: FirstPageOfTwoStub())
    }

    func givenSutWithSecondPageOfTwoTotalPages() {
        sut.update(currentPage: FirstPageOfTwoStub())
    }
}

private class FirstPageOfTwoStub: Pageable {
    let offset: Int? = 0
    let limit: Int? = 20
    let total: Int? = 40
    let count: Int? = 20
}

private class SecondPageOfTwoStub: Pageable {
    let offset: Int? = 20
    let limit: Int? = 40
    let total: Int? = 40
    let count: Int? = 20
}
