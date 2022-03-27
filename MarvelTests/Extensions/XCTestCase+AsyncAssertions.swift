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

    func assertThrows<T: Error & Equatable>(
        _ asyncBlock: () async throws -> Void,
        expectedError: T,
        line: UInt = #line,
        file: StaticString = #filePath
    ) async {
        do {
            try await asyncBlock()
            failExpectingErrorMatching(expectedError, file: file, line: line)
        } catch let error as T {
            XCTAssertEqual(error, expectedError, file: file, line: line)
        } catch {
            failExpectingErrorMatching(expectedError, file: file, line: line)
        }
    }

    func assertThrowsError(
        _ asyncBlock: () async throws -> Void,
        didCatchErrorBlock: (Error) -> Void,
        line _: UInt = #line,
        file _: StaticString = #filePath
    ) async {
        do {
            try await asyncBlock()
            XCTFail("Expected an error, but no error was thrown from the provided asnyc block.")
        } catch {
            didCatchErrorBlock(error)
        }
    }
}
