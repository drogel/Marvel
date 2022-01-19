//
//  XCTestCase+ResultAssertions.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation
import XCTest

extension XCTestCase {
    
    /// Asserts whether the provided ``Result`` is of case ``.success``. Additional assertions can be provided via the ``then`` parameter.
    func assertIsSuccess<T, E>(
        _ result: Result<T, E>,
        then assertions: (T) -> Void = { _ in },
        message: (E) -> String = { "Expected success but got failure with \($0) "},
        file: StaticString = #filePath,
        line: UInt = #line
    ) where E: Error {
        switch result {
        case .failure(let error):
            XCTFail(message(error), file: file, line: line)
        case .success(let value):
            assertions(value)
        }
    }

    /// Asserts whether the provided ``Result`` is of case ``.failure``. Additional assertions can be provided via the ``then`` parameter.
    func assertIsFailure<T, E>(
        _ result: Result<T, E>,
        then assertions: (E) -> Void = { _ in },
        message: (T) -> String = { "Expected failure but got success with \($0) "},
        file: StaticString = #filePath,
        line: UInt = #line
    ) where E: Error {
        switch result {
        case .failure(let error):
            assertions(error)
        case .success(let value):
            XCTFail(message(value), file: file, line: line)
        }
    }
}
