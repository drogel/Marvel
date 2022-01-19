//
//  DataWrapperTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 18/1/22.
//

import XCTest
@testable import Marvel

class DataWrapperTests: XCTestCase {

    typealias ParseableObjectType = DataWrapper

    func test_givenDataWrapperFromJson_parsesExpectedValues() {
        runParsingTest()
    }
}

extension DataWrapperTests: ParsingTestCaseTemplate {

    func buildExpectedObject() -> DataWrapper {
        DataWrapper(code: 200, status: "Ok", copyright: "© 2022 MARVEL", data: nil)
    }
}
