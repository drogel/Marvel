//
//  CharacterDetailPresentationModel.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Combine
import Foundation

// TODO: Rename all references of presentation model to view models when we migrate these models to Combine too
typealias CharacterDetailPresentationModels = CharacterInfoPresentationModelProtocol & ComicsPresentationModelProtocol

protocol CharacterDetailPresentationModelProtocol: CharacterDetailPresentationModels {}

protocol CharacterDetailPresentationModelViewDelegate: AnyObject {
    func modelDidStartLoading(_ presentationModel: CharacterDetailPresentationModelProtocol)
    func modelDidFinishLoading(_ presentationModel: CharacterDetailPresentationModelProtocol)
    func modelDidRetrieveCharacterInfo(_ presentationModel: CharacterDetailPresentationModelProtocol)
    func modelDidRetrieveComics(_ presentationModel: CharacterDetailPresentationModelProtocol)
    func model(_ presentationModel: CharacterDetailPresentationModelProtocol, didFailWithError message: String)
}

class CharacterDetailPresentationModel: CharacterDetailPresentationModelProtocol {
    weak var viewDelegate: CharacterDetailPresentationModelViewDelegate?

    var imageCellData: CharacterImageModel? {
        infoPresentationModel.imageCellData
    }

    var infoCellData: CharacterInfoModel? {
        infoPresentationModel.infoCellData
    }

    var comicCellModelsPublisher: AnyPublisher<[ComicCellModel], Never> {
        comicsPresentationModel.comicCellModelsPublisher
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
