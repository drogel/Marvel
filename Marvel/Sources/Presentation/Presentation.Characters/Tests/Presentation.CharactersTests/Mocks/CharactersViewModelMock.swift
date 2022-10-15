//
//  CharactersViewModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 4/3/22.
//

import Combine
import Foundation
@testable import Presentation_Characters
import Presentation_Common

class CharactersViewModelMock: ViewModelMock, CharactersViewModelProtocol {
    var numberOfItemsCallCount = 0
    var cellModelsPublisherCallCount = 0
    var willDisplayCellCallCount = 0
    var selectCallCount = 0
    var cellDataCallCount = 0
    var loadingStatePublisherCallCount = 0

    var numberOfItems: Int {
        numberOfItemsCallCount += 1
        return 0
    }

    var cellModelsStub = CurrentValueSubject<CharactersViewModelState, Never>(.success([]))

    var loadingStatePublisher: AnyPublisher<LoadingState, Never> {
        loadingStatePublisherCallCount += 1
        return Just(LoadingState.loading).eraseToAnyPublisher()
    }

    var statePublisher: AnyPublisher<CharactersViewModelState, Never> {
        cellModelsPublisherCallCount += 1
        return cellModelsStub.eraseToAnyPublisher()
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
}
