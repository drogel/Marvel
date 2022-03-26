//
//  XCTestCase+AsyncAssertions.swift
//  MarvelTests
//
//  Created by Diego Rogel on 20/3/22.
//

import Foundation
import XCTest

extension XCTestCase {
    func assertThrows(_ asyncBlock: () async throws -> Void, line: UInt = #line, file: StaticString = #filePath) async {
        do {
            try await asyncBlock()
            XCTFail("Expected an error thrown, but provided block did not throw any errors.", file: file, line: line)
        } catch {}
    }
}
