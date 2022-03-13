//
//  CharacterDetailInfoPresentationModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Combine
import Foundation
@testable import Marvel_Debug

class CharacterDetailInfoPresentationModelMock: CharacterInfoPresentationModelProtocol {
    var infoStatePublisherCallCount = 0
    var startCallCount = 0
    var disposeCallCount = 0
    var imageCellDataCallCount = 0
    var infoCellDataCallCount = 0

    var infoStatePublisher: AnyPublisher<CharacterInfoViewModelState, Never> {
        infoStatePublisherCallCount += 1
        return Just(CharacterInfoViewModelState.success(nil)).eraseToAnyPublisher()
    }

    var imageCellData: CharacterImageModel? {
        imageCellDataCallCount += 1
        return nil
    }

    var infoCellData: CharacterDescriptionModel? {
        infoCellDataCallCount += 1
        return nil
    }

    func start() {
        startCallCount += 1
    }

    func dispose() {
        disposeCallCount += 1
    }
}
