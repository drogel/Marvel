//
//  PageInfoTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import XCTest
@testable import Marvel

class PageInfoTests: XCTestCase {

    typealias ParseableObjectType = PageInfo

    func test_givenPageInfoFromJson_parsesExpectedValues() {
        runParsingTest()
    }
}

extension PageInfoTests: ParsingTestCaseTemplate {

    func buildExpectedObject() -> PageInfo {
        PageInfo(offset: 0, limit: 20, total: 1559, count: 20, results: nil)
    }
}
