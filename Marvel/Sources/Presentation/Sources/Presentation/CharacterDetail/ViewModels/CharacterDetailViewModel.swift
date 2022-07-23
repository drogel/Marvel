//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Combine
import Foundation

protocol CharacterDetailViewModelProtocol: ViewModel {
    var detailStatePublisher: AnyPublisher<CharacterDetailViewModelState, Never> { get }
    func willDisplayComicCell(at indexPath: IndexPath) async
}

typealias CharacterDetailViewModelError = CharacterInfoViewModelError

typealias CharacterDetailViewModelState = Result<CharacterDetailModel, CharacterInfoViewModelError>

class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    var detailStatePublisher: AnyPublisher<CharacterDetailViewModelState, Never> {
        infoViewModel.infoStatePublisher
            .combineLatest(comicsViewModel.comicCellModelsPublisher)
            .map(mapToCharacterDetailState)
            .eraseToAnyPublisher()
    }

    private let infoViewModel: CharacterInfoViewModelProtocol
    private let comicsViewModel: ComicsViewModelProtocol

    init(infoViewModel: CharacterInfoViewModelProtocol, comicsViewModel: ComicsViewModelProtocol) {
        self.infoViewModel = infoViewModel
        self.comicsViewModel = comicsViewModel
    }

    func start() async {
        async let startInfo: Void = infoViewModel.start()
        async let startComics: Void = comicsViewModel.start()
        _ = await [startInfo, startComics]
    }

    func willDisplayComicCell(at indexPath: IndexPath) async {
        await comicsViewModel.willDisplayComicCell(at: indexPath)
    }
}

private extension CharacterDetailViewModel {
    func mapToCharacterDetailState(
        _ combination: (characterInfoState: CharacterInfoViewModelState, comicCellModels: [ComicCellModel])
    ) -> CharacterDetailViewModelState {
        switch combination.characterInfoState {
        case let .success(infoModel):
            let detailModel = CharacterDetailModel(info: infoModel, comics: combination.comicCellModels)
            return .success(detailModel)
        case let .failure(error):
            return .failure(error)
        }
    }
}
