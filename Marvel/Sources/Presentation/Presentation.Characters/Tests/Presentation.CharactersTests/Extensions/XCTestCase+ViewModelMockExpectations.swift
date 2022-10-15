//
//  XCTestCase+ViewModelMockExpectations.swift
//  MarvelTests
//
//  Created by Diego Rogel on 27/3/22.
//

import Foundation
import XCTest

extension XCTestCase {
    func startDidCallExpectation(on viewModelMock: ViewModelMock) -> XCTestExpectation {
        expectation(on: viewModelMock) { $0.startCallCount == 1 }
    }

    func expectation(
        on viewModelMock: ViewModelMock,
        until predicateBlock: @escaping (ViewModelMock) -> Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> XCTestExpectation {
        let predicate = NSPredicate { viewModel, _ in
            guard let viewModel = viewModel as? ViewModelMock else {
                XCTFail(
                    "Expected a \(String(describing: ViewModelMock.self)), got \(String(describing: viewModel)).",
                    file: file,
                    line: line
                )
                return false
            }
            return predicateBlock(viewModel)
        }
        let expectation = expectation(for: predicate, evaluatedWith: viewModelMock, handler: nil)
        return expectation
    }
}
