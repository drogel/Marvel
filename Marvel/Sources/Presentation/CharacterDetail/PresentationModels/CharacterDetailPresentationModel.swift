//
//  CharacterDetailPresentationModel.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Combine
import Foundation

// TODO: Rename all references of presentation model to view models when we migrate these models to Combine too
protocol CharacterDetailPresentationModelProtocol: PresentationModel {
    var detailStatePublisher: AnyPublisher<CharacterDetailViewModelState, Never> { get }
    func willDisplayComicCell(at indexPath: IndexPath)
}

// TODO: Remove all these delegates
protocol CharacterDetailPresentationModelViewDelegate: AnyObject {
    func modelDidStartLoading(_ presentationModel: CharacterDetailPresentationModelProtocol)
    func modelDidFinishLoading(_ presentationModel: CharacterDetailPresentationModelProtocol)
    func modelDidRetrieveCharacterInfo(_ presentationModel: CharacterDetailPresentationModelProtocol)
    func modelDidRetrieveComics(_ presentationModel: CharacterDetailPresentationModelProtocol)
    func model(_ presentationModel: CharacterDetailPresentationModelProtocol, didFailWithError message: String)
}

typealias CharacterDetailViewModelError = CharacterInfoViewModelError

typealias CharacterDetailViewModelState = Result<CharacterDetailModel, CharacterInfoViewModelError>

class CharacterDetailPresentationModel: CharacterDetailPresentationModelProtocol {
    weak var viewDelegate: CharacterDetailPresentationModelViewDelegate?

    var detailStatePublisher: AnyPublisher<CharacterDetailViewModelState, Never> {
        infoPresentationModel.infoStatePublisher
            .combineLatest(comicsViewModel.comicCellModelsPublisher)
            .map(mapToCharacterDetailState)
            .eraseToAnyPublisher()
    }

    private let infoPresentationModel: CharacterInfoPresentationModelProtocol
    private let comicsViewModel: ComicsViewModelProtocol

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

private extension CharacterDetailPresentationModel {
    func mapToCharacterDetailState(
        _ combination: (characterInfoState: CharacterInfoViewModelState, comicCellModels: [ComicCellModel])
    ) -> CharacterDetailViewModelState {
        switch combination.characterInfoState {
        case let .success(infoModel):
            let detailModel = CharacterDetailModel(info: infoModel, comics: combination.comicCellModels)
            return CharacterDetailViewModelState.success(detailModel)
        case let .failure(error):
            return CharacterDetailViewModelState.failure(error)
        }
    }
}
