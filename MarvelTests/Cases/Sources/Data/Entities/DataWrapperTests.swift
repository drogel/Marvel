//
//  DataWrapperTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 18/1/22.
//

@testable import Marvel_Debug
import XCTest

class DataWrapperTests: XCTestCase {
    typealias ParseableObjectType = DataWrapper<CharacterData>

    var parseableObjectJSONFileName: String {
        "DataWrapper"
    }

    func test_givenDataWrapperFromJson_parsesExpectedValues() {
        runParsingTest()
    }
}

extension DataWrapperTests: ParsingTestCaseTemplate {
    func buildExpectedObject() -> DataWrapper<CharacterData> {
        DataWrapper<CharacterData>(code: 200, status: "Ok", copyright: "© 2022 MARVEL", data: nil)
    }
}
