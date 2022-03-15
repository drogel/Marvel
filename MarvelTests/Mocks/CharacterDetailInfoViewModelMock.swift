//
//  CharacterDetailInfoViewModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Combine
import Foundation
@testable import Marvel_Debug

class CharacterDetailInfoViewModelMock: CharacterInfoViewModelProtocol {
    static let emitedInfoViewModelState: CharacterInfoModel? = nil

    var infoStatePublisherCallCount = 0
    var loadingStatePublisherCallCount = 0
    var startCallCount = 0
    var disposeCallCount = 0

    var infoStatePublisher: AnyPublisher<CharacterInfoViewModelState, Never> {
        infoStatePublisherCallCount += 1
        return Just(.success(Self.emitedInfoViewModelState)).eraseToAnyPublisher()
    }

    var loadingStatePublisher: AnyPublisher<LoadingState, Never> {
        loadingStatePublisherCallCount += 1
        return Just(LoadingState.idle).eraseToAnyPublisher()
    }

    func start() {
        startCallCount += 1
    }

    func dispose() {
        disposeCallCount += 1
    }
}
