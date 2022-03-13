//
//  CharacterDetailPresentationModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 6/3/22.
//

import Combine
import Foundation
@testable import Marvel_Debug

class CharacterDetailPresentationModelMock: PresentationModelMock, CharacterDetailPresentationModelProtocol {
    var comicCellModelsPublisher: AnyPublisher<[ComicCellModel], Never> {
        Just([]).eraseToAnyPublisher()
    }

    var comicsSectionTitle: String = ""

    var imageCellData: CharacterImageModel?

    var infoCellData: CharacterDescriptionModel?

    func willDisplayComicCell(at _: IndexPath) {}
}
