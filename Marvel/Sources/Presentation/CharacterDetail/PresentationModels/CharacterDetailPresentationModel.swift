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

typealias CharacterDetailViewModelError = CharacterInfoViewModelError

typealias CharacterDetailViewModelState = Result<CharacterDetailModel, CharacterInfoViewModelError>

class CharacterDetailPresentationModel: CharacterDetailPresentationModelProtocol {
    var detailStatePublisher: AnyPublisher<CharacterDetailViewModelState, Never> {
        infoViewModel.infoStatePublisher
            .combineLatest(comicsViewModel.comicCellModelsPublisher)
            .map(mapToCharacterDetailState)
            .eraseToAnyPublisher()
    }

    private let infoViewModel: CharacterInfoViewModelProtocol
    private let comicsViewModel: ComicsViewModelProtocol

    init(
        infoViewModel: CharacterInfoViewModelProtocol,
        comicsViewModel: ComicsViewModelProtocol
    ) {
        self.infoViewModel = infoViewModel
        self.comicsViewModel = comicsViewModel
    }

    func start() {
        infoViewModel.start()
        comicsViewModel.start()
    }

    func willDisplayComicCell(at indexPath: IndexPath) {
        comicsViewModel.willDisplayComicCell(at: indexPath)
    }

    func dispose() {
        infoViewModel.dispose()
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
