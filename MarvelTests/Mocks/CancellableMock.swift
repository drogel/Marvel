//
//  CancellableMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
@testable import Marvel_Debug

class CancellableMock: Cancellable {
    var didCancelCallCount = 0

    func cancel() {
        didCancelCallCount += 1
    }
}
