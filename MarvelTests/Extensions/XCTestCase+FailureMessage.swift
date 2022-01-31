//
//  XCTestCase+FailureMessage.swift
//  MarvelTests
//
//  Created by Diego Rogel on 31/1/22.
//

import Foundation
import XCTest

extension XCTestCase {
    func failExpectingErrorMatching(_ actualError: Error, file: StaticString = #filePath, line: UInt = #line) {
        XCTFail("Did not expect failure with error \(actualError)", file: file, line: line)
    }
}
