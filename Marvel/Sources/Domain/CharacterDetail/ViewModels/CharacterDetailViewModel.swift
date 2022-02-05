//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation

protocol CharacterDetailViewModelProtocol: CharacterDetailInfoViewModelProtocol, ComicsViewModelProtocol {}

class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    var imageCellData: CharacterImageData? {
        infoViewModel.imageCellData
    }

    var infoCellData: CharacterInfoData? {
        infoViewModel.infoCellData
    }

    var numberOfComics: Int {
        comicsViewModel.numberOfComics
    }

    private var infoViewModel: CharacterDetailInfoViewModelProtocol
    private var comicsViewModel: ComicsViewModelProtocol

    init(infoViewModel: CharacterDetailInfoViewModelProtocol, comicsViewModel: ComicsViewModelProtocol) {
        self.infoViewModel = infoViewModel
        self.comicsViewModel = comicsViewModel
    }

    func start() {
        infoViewModel.start()
        comicsViewModel.start()
    }

    func comicCellData(at indexPath: IndexPath) -> ComicCellData? {
        comicsViewModel.comicCellData(at: indexPath)
    }

    func dispose() {
        infoViewModel.dispose()
        comicsViewModel.dispose()
    }
}
