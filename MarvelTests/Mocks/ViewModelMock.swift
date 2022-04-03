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
    var startCallCount = 0

    func start() {
        startCallCount += 1
    }

    func assertStart(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(startCallCount, callCount, line: line)
    }
}
