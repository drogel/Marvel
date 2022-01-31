//
//  ParsingTestCaseTemplate.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation
import XCTest

/// Helper base template to easily build test cases in which the main focus is testing object parsing.
protocol ParsingTestCaseTemplate: ParsingTester {
    /// Runs the parsing test, based on a template that delegates the expected object creation to the classes
    /// that conform to ``ParsingTestCaseTemplate``.
    func runParsingTest(filePath: StaticString, line: UInt)

    /// Builds the object that will be used as the expectation for a parsing test.
    /// Classes conforming to ``ParsingTestCaseTemplate`` need to implement this to return the specific
    /// associated parseable object.
    /// - Returns: An instance of the object specified in the associated type of ``ParsingTester`` that contains
    /// the parsed data from a JSON named after the runtime type of ``ParseableObjectType``.
    func buildExpectedObject() -> ParseableObjectType
}

extension ParsingTestCaseTemplate where Self: XCTestCase {
    func runParsingTest(filePath: StaticString = #filePath, line: UInt = #line) {
        let actual = givenParsedObjectFromJson()
        let expected = buildExpectedObject()
        XCTAssertEqual(actual, expected, file: filePath, line: line)
    }
}
