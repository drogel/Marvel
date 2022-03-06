//
//  CharacterDetailPresentationModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 6/3/22.
//

import Foundation
@testable import Marvel_Debug

class CharacterDetailPresentationModelMock: PresentationModelMock, CharacterDetailPresentationModelProtocol {
    var comicCellModels: [ComicCellModel] = []

    var comicsSectionTitle: String = ""

    var imageCellData: CharacterImageModel?

    var infoCellData: CharacterInfoModel?

    func willDisplayComicCell(at _: IndexPath) {}
}
