//
//  CancellableMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
@testable import Marvel_Debug

class DisposableMock: Disposable {
    var didDisposeCallCount = 0

    func cancel() {
        didDisposeCallCount += 1
    }
}
