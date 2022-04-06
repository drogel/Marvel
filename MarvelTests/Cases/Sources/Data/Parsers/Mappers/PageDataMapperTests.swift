//
//  PageDataMapperTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 13/2/22.
//

@testable import Marvel_Debug
import XCTest
import Domain

class PageDataMapperTests: XCTestCase {
    private var sut: PageDataMapper!

    override func setUp() {
        super.setUp()
        sut = PageDataMapper()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_conformsToPageMapper() {
        XCTAssertTrue((sut as AnyObject) is PageMapper)
    }

    func test_givenAValidPageable_returnsExpectedPageInfo() throws {
        let pageable: Pageable = PageData<CharacterData>.atFirstPageOfTwoTotal(results: [])
        let expectedPageInfo = buildExpectedPageInfo(from: pageable)
        let acutalPageInfo = try XCTUnwrap(sut.mapToPageInfo(pageable))
        XCTAssertEqual(acutalPageInfo, expectedPageInfo)
    }
}

private extension PageDataMapperTests {
    func buildExpectedPageInfo(from pageable: Pageable) -> PageInfo {
        PageInfo(offset: pageable.offset!, limit: pageable.limit!, total: pageable.total!)
    }
}
