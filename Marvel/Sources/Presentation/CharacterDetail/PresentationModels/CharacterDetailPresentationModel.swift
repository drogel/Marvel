//
//  CharacterDetailPresentationModel.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Combine
import Foundation

// TODO: Rename all references of presentation model to view models when we migrate these models to Combine too
typealias CharacterDetailPresentationModels = CharacterInfoPresentationModelProtocol & ComicsViewModelProtocol

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

    var infoCellData: CharacterDescriptionModel? {
        infoPresentationModel.infoCellData
    }

    var comicCellModelsPublisher: AnyPublisher<[ComicCellModel], Never> {
        comicsViewModel.comicCellModelsPublisher
    }

    private var infoPresentationModel: CharacterInfoPresentationModelProtocol
    private var comicsViewModel: ComicsViewModelProtocol

    init(
        infoPresentationModel: CharacterInfoPresentationModelProtocol,
        comicsViewModel: ComicsViewModelProtocol
    ) {
        self.infoPresentationModel = infoPresentationModel
        self.comicsViewModel = comicsViewModel
    }

    func start() {
        infoPresentationModel.start()
        comicsViewModel.start()
    }

    func willDisplayComicCell(at indexPath: IndexPath) {
        comicsViewModel.willDisplayComicCell(at: indexPath)
    }

    func dispose() {
        infoPresentationModel.dispose()
        comicsViewModel.dispose()
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
