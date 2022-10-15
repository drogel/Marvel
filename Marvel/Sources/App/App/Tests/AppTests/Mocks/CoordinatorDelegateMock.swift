//
//  CoordinatorDelegateMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 1/2/22.
//

@testable import App
import Foundation

class CoordinatorDelegateMock: CoordinatorDelegate {
    var didFinishCallCount = 0

    func coordinatorDidFinish(_: Coordinator) {
        didFinishCallCount += 1
    }
}
