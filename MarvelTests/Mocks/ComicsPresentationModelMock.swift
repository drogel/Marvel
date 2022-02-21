//
//  ComicsPresentationModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation
@testable import Marvel_Debug

class ComicsPresentationModelMock: ComicsPresentationModelProtocol {
    var startCallCount = 0
    var disposeCallCount = 0
    var numberOfComicsCallCount = 0
    var comicsCellDataCallCount = 0
    var willDisplayComicCellCallCount = 0

    var numberOfComics: Int {
        numberOfComicsCallCount += 1
        return 0
    }

    func start() {
        startCallCount += 1
    }

    func comicCellData(at _: IndexPath) -> ComicCellModel? {
        comicsCellDataCallCount += 1
        return nil
    }

    func willDisplayComicCell(at _: IndexPath) {
        willDisplayComicCellCallCount += 1
    }

    func dispose() {
        disposeCallCount += 1
    }
}
