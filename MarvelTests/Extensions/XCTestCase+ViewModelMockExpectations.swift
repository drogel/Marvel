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
        until predicateBlock: @escaping (ViewModelMock) -> Bool
    ) -> XCTestExpectation {
        let predicate = NSPredicate { viewModel, _ in
            predicateBlock(viewModel as! ViewModelMock)
        }
        let expectation = expectation(for: predicate, evaluatedWith: viewModelMock, handler: nil)
        return expectation
    }
}
