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
        XCTAssertTrue(sut.isThereMoreContent(at: 39))
    }

    func test_givenOffsetDidReachTotal_isThereMoreContent_returnsFalse() {
        givenSutWithFirstPageOfTwoTotalPages()
        XCTAssertFalse(sut.isThereMoreContent(at: 40))
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
        XCTAssertTrue(sut.isAtEndOfCurrentPage(20))
        XCTAssertTrue(sut.isAtEndOfCurrentPage(19))
        XCTAssertTrue(sut.isAtEndOfCurrentPage(39))
    }

    func test_givenNoPage_isAtEndOfCurrentPage_returnsFalse() {
        XCTAssertFalse(sut.isAtEndOfCurrentPage(0))
    }
}

private extension OffsetPagerTests {
    func givenSutWithFirstPageOfTwoTotalPages() {
        sut.update(currentPage: FirstPageOfTwoStub())
    }
}

private class FirstPageOfTwoStub: Page {
    let offset: Int? = 0
    let limit: Int? = 20
    let total: Int? = 40
    let count: Int? = 20
}
