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
    var numberOfComicsCallCount = 0
    var comicsCellDataCallCount = 0

    var numberOfComics: Int {
        numberOfComicsCallCount += 1
        return 0
    }

    func comicCellData(at _: IndexPath) -> ComicCellData? {
        comicsCellDataCallCount += 1
        return nil
    }

    func start() {
        startCallCount += 1
    }

    func dispose() {
        disposeCallCount += 1
    }
}
