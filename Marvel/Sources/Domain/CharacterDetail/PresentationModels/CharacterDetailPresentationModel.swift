//
//  CharacterDetailPresentationModel.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation

typealias CharacterDetailPresentationModels = CharacterInfoPresentationModelProtocol & ComicsPresentationModelProtocol

protocol CharacterDetailPresentationModelProtocol: CharacterDetailPresentationModels {
    var comicsSectionTitle: String { get }
}

protocol CharacterDetailPresentationModelViewDelegate: AnyObject {
    func modelDidStartLoading(_ presentationModel: CharacterDetailPresentationModelProtocol)
    func modelDidFinishLoading(_ presentationModel: CharacterDetailPresentationModelProtocol)
    func modelDidRetrieveCharacterInfo(_ presentationModel: CharacterDetailPresentationModelProtocol)
    func modelDidRetrieveComics(_ presentationModel: CharacterDetailPresentationModelProtocol)
    func model(_ presentationModel: CharacterDetailPresentationModelProtocol, didFailWithError message: String)
}

class CharacterDetailPresentationModel: CharacterDetailPresentationModelProtocol {
    weak var viewDelegate: CharacterDetailPresentationModelViewDelegate?

    var comicsSectionTitle: String {
        "comics".localized
    }

    var imageCellData: CharacterImageData? {
        infoPresentationModel.imageCellData
    }

    var infoCellData: CharacterInfoData? {
        infoPresentationModel.infoCellData
    }

    var numberOfComics: Int {
        comicsPresentationModel.numberOfComics
    }

    private var infoPresentationModel: CharacterInfoPresentationModelProtocol
    private var comicsPresentationModel: ComicsPresentationModelProtocol

    init(
        infoPresentationModel: CharacterInfoPresentationModelProtocol,
        comicsPresentationModel: ComicsPresentationModelProtocol
    ) {
        self.infoPresentationModel = infoPresentationModel
        self.comicsPresentationModel = comicsPresentationModel
    }

    func start() {
        infoPresentationModel.start()
        comicsPresentationModel.start()
    }

    func comicCellData(at indexPath: IndexPath) -> ComicCellData? {
        comicsPresentationModel.comicCellData(at: indexPath)
    }

    func willDisplayComicCell(at indexPath: IndexPath) {
        comicsPresentationModel.willDisplayComicCell(at: indexPath)
    }

    func dispose() {
        infoPresentationModel.dispose()
        comicsPresentationModel.dispose()
    }
}

extension CharacterDetailPresentationModel: CharacterInfoPresentationModelViewDelegate {
    func modelDidStartLoading(_: CharacterInfoPresentationModelProtocol) {
        viewDelegate?.modelDidStartLoading(self)
    }

    func modelDidFinishLoading(_: CharacterInfoPresentationModelProtocol) {
        viewDelegate?.modelDidFinishLoading(self)
    }

    func modelDidRetrieveData(_: CharacterInfoPresentationModelProtocol) {
        viewDelegate?.modelDidRetrieveCharacterInfo(self)
    }

    func model(_: CharacterInfoPresentationModelProtocol, didFailWithError message: String) {
        viewDelegate?.model(self, didFailWithError: message)
    }
}

extension CharacterDetailPresentationModel: ComicsPresentationModelViewDelegate {
    func modelDidStartLoading(_: ComicsPresentationModelProtocol) {}

    func modelDidFinishLoading(_: ComicsPresentationModelProtocol) {}

    func modelDidRetrieveData(_: ComicsPresentationModelProtocol) {
        viewDelegate?.modelDidRetrieveComics(self)
    }

    func modelDidFailRetrievingData(_: ComicsPresentationModelProtocol) {}
}
