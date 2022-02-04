//
//  PageInfo<CharacterData>Tests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

@testable import Marvel_Debug
import XCTest

class PageInfoTests: XCTestCase {
    typealias ParseableObjectType = PageInfo<CharacterData>

    var parseableObjectJSONFileName: String {
        "PageInfo"
    }

    func test_givenPageInfoFromJson_parsesExpectedValues() {
        runParsingTest()
    }
}

extension PageInfoTests: ParsingTestCaseTemplate {
    func buildExpectedObject() -> PageInfo<CharacterData> {
        PageInfo<CharacterData>(offset: 0, limit: 20, total: 1559, count: 20, results: nil)
    }
}
