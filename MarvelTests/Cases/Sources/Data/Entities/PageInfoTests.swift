//
//  PageDataTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

@testable import Marvel_Debug
import XCTest

class PageDataTests: XCTestCase {
    typealias ParseableObjectType = PageData<CharacterData>

    var parseableObjectJSONFileName: String {
        "PageData"
    }

    func test_givenPageDataFromJson_parsesExpectedValues() {
        runParsingTest()
    }
}

extension PageDataTests: ParsingTestCaseTemplate {
    func buildExpectedObject() -> PageData<CharacterData> {
        PageData<CharacterData>(offset: 0, limit: 20, total: 1559, count: 20, results: nil)
    }
}
