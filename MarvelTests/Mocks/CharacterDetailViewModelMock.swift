//
//  CharacterDetailViewModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 6/3/22.
//

import Combine
import Foundation
@testable import Marvel_Debug

class CharacterDetailViewModelMock: ViewModelMock, CharacterDetailViewModelProtocol {
    var detailStatePublisher: AnyPublisher<CharacterDetailViewModelState, Never> {
        Just(CharacterDetailViewModelState.success(CharacterDetailModel(info: nil, comics: []))).eraseToAnyPublisher()
    }

    var infoStatePublisher: AnyPublisher<CharacterInfoViewModelState, Never> {
        Just(CharacterInfoViewModelState.success(nil)).eraseToAnyPublisher()
    }

    var comicCellModelsPublisher: AnyPublisher<[ComicCellModel], Never> {
        Just([]).eraseToAnyPublisher()
    }

    var comicsSectionTitle: String = ""

    var imageCellData: CharacterImageModel?

    var infoCellData: CharacterDescriptionModel?

    func willDisplayComicCell(at _: IndexPath) {}
}
