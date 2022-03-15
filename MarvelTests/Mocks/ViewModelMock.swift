//
//  ViewModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation
@testable import Marvel_Debug
import XCTest

class ViewModelMock: ViewModel {
    private var startCallCount = 0
    private var disposeCallCount = 0

    func start() {
        startCallCount += 1
    }

    func dispose() {
        disposeCallCount += 1
    }

    func assertStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(startCallCount, callCount, line: line)
    }

    func assertDispose(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(disposeCallCount, callCount, line: line)
    }
}
