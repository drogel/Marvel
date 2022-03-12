//
//  ComicsPresentationModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Combine
import Foundation
@testable import Marvel_Debug

class ComicsPresentationModelMock: ComicsPresentationModelProtocol {
    var startCallCount = 0
    var comicCellModelsPublisherCallCount = 0
    var disposeCallCount = 0
    var willDisplayComicCellCallCount = 0

    var comicCellModelsPublisher: AnyPublisher<[ComicCellModel], Never> {
        comicCellModelsPublisherCallCount += 1
        return Just([]).eraseToAnyPublisher()
    }

    func start() {
        startCallCount += 1
    }

    func willDisplayComicCell(at _: IndexPath) {
        willDisplayComicCellCallCount += 1
    }

    func dispose() {
        disposeCallCount += 1
    }
}
