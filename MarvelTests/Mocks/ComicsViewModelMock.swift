//
//  ComicsViewModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Combine
import Foundation
@testable import Marvel_Debug

class ComicsViewModelMock: ComicsViewModelProtocol {
    static let emittedComicCellModels: [ComicCellModel] = []

    var startCallCount = 0
    var comicCellModelsPublisherCallCount = 0
    var willDisplayComicCellCallCount = 0

    var comicCellModelsPublisher: AnyPublisher<[ComicCellModel], Never> {
        comicCellModelsPublisherCallCount += 1
        return Just(Self.emittedComicCellModels).eraseToAnyPublisher()
    }

    func start() {
        startCallCount += 1
    }

    func willDisplayComicCell(at _: IndexPath) {
        willDisplayComicCellCallCount += 1
    }
}
