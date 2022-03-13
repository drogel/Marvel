//
//  CharacterDetailInfoPresentationModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation
@testable import Marvel_Debug

class CharacterDetailInfoPresentationModelMock: CharacterInfoPresentationModelProtocol {
    var startCallCount = 0
    var disposeCallCount = 0
    var imageCellDataCallCount = 0
    var infoCellDataCallCount = 0

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
