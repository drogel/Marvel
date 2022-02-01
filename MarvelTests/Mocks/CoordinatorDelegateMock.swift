//
//  CoordinatorDelegateMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 1/2/22.
//

import Foundation
@testable import Marvel_Debug

class CoordinatorDelegateMock: CoordinatorDelegate {
    var didFinishCallCount = 0

    func coordinatorDidFinish(_ coordinator: Coordinator) {
        didFinishCallCount += 1
    }
}
