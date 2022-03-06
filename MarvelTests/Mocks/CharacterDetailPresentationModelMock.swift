//
//  CharacterDetailPresentationModelMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 6/3/22.
//

import Foundation
@testable import Marvel_Debug

class CharacterDetailPresentationModelMock: PresentationModelMock, CharacterDetailPresentationModelProtocol {
    var comicsSectionTitle: String = ""

    var imageCellData: CharacterImageModel?

    var infoCellData: CharacterInfoModel?

    var numberOfComics: Int = 0

    func comicCellData(at _: IndexPath) -> ComicCellModel? {
        nil
    }

    func willDisplayComicCell(at _: IndexPath) {}
}
