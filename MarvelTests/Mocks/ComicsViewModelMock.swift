//
//  ComicsViewModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation
@testable import Marvel_Debug

class ComicsViewModelMock: ComicsViewModelProtocol {
    var startCallCount = 0
    var disposeCallCount = 0
    var numberOfItemsCallCount = 0
    var cellDataCallCount = 0

    var numberOfItems: Int {
        numberOfItemsCallCount += 1
        return 0
    }

    func cellData(at _: IndexPath) -> ComicCellData? {
        cellDataCallCount += 1
        return nil
    }

    func start() {
        startCallCount += 1
    }

    func dispose() {
        disposeCallCount += 1
    }
}
