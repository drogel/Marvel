//
//  CharactersPresentationModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 4/3/22.
//

import Foundation
@testable import Marvel_Debug

class CharactersPresentationModelMock: CharactersPresentationModelProtocol {
    var numberOfItemsCallCount = 0
    var cellModelsCallCount = 0
    var willDisplayCellCallCount = 0
    var selectCallCount = 0
    var cellDataCallCount = 0
    var startCallCount = 0
    var disposeCallCount = 0

    var numberOfItems: Int {
        numberOfItemsCallCount += 1
        return 0
    }

    var cellModels: [CharacterCellModel] {
        cellModelsCallCount += 1
        return []
    }

    func willDisplayCell(at _: IndexPath) {
        willDisplayCellCallCount += 1
    }

    func select(at _: IndexPath) {
        selectCallCount += 1
    }

    func cellModel(at _: IndexPath) -> CharacterCellModel? {
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
