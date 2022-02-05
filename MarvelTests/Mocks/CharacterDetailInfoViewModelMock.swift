//
//  CharacterDetailInfoViewModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation
@testable import Marvel_Debug

class CharacterDetailInfoViewModelMock: CharacterDetailInfoViewModelProtocol {
    var startCallCount = 0
    var disposeCallCount = 0
    var imageCellDataCallCount = 0
    var infoCellDataCallCount = 0

    var imageCellData: CharacterImageData? {
        imageCellDataCallCount += 1
        return nil
    }

    var infoCellData: CharacterInfoData? {
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
