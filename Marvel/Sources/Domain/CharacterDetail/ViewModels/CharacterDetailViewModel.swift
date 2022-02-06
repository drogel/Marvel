//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation

protocol CharacterDetailViewModelProtocol: CharacterDetailInfoViewModelProtocol, ComicsViewModelProtocol {
    var comicsSectionTitle: String { get }
}

protocol CharacterDetailViewModelViewDelegate: AnyObject {
    func viewModelDidStartLoading(_ viewModel: CharacterDetailViewModelProtocol)
    func viewModelDidFinishLoading(_ viewModel: CharacterDetailViewModelProtocol)
    func viewModelDidRetrieveCharacterInfo(_ viewModel: CharacterDetailViewModelProtocol)
    func viewModelDidRetrieveComics(_ viewModel: CharacterDetailViewModelProtocol)
    func viewModel(_ viewModel: CharacterDetailViewModelProtocol, didFailWithError message: String)
}

class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    weak var viewDelegate: CharacterDetailViewModelViewDelegate?

    var comicsSectionTitle: String {
        "comics".localized
    }

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

    func willDisplayComicCell(at indexPath: IndexPath) {
        comicsViewModel.willDisplayComicCell(at: indexPath)
    }

    func dispose() {
        infoViewModel.dispose()
        comicsViewModel.dispose()
    }
}

extension CharacterDetailViewModel: CharacterDetailInfoViewModelViewDelegate {
    func viewModelDidStartLoading(_: CharacterDetailInfoViewModelProtocol) {
        viewDelegate?.viewModelDidStartLoading(self)
    }

    func viewModelDidFinishLoading(_: CharacterDetailInfoViewModelProtocol) {
        viewDelegate?.viewModelDidFinishLoading(self)
    }

    func viewModelDidRetrieveData(_: CharacterDetailInfoViewModelProtocol) {
        viewDelegate?.viewModelDidRetrieveCharacterInfo(self)
    }

    func viewModel(_: CharacterDetailInfoViewModelProtocol, didFailWithError message: String) {
        viewDelegate?.viewModel(self, didFailWithError: message)
    }
}

extension CharacterDetailViewModel: ComicsViewModelViewDelegate {
    func viewModelDidStartLoading(_: ComicsViewModelProtocol) {}

    func viewModelDidFinishLoading(_: ComicsViewModelProtocol) {}

    func viewModelDidRetrieveData(_: ComicsViewModelProtocol) {
        viewDelegate?.viewModelDidRetrieveComics(self)
    }

    func viewModelDidFailRetrievingData(_: ComicsViewModelProtocol) {}
}
