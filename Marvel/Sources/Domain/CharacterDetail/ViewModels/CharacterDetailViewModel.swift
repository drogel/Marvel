//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

protocol CharacterDetailViewModelProtocol: ViewModel { }

protocol CharacterDetailViewModelViewDelegate: AnyObject {
    func viewModelDidStartLoading(_ viewModel: CharacterDetailViewModelProtocol)
    func viewModelDidFinishLoading(_ viewModel: CharacterDetailViewModelProtocol)
}

class CharacterDetailViewModel: CharacterDetailViewModelProtocol {

    weak var viewDelegate: CharacterDetailViewModelViewDelegate?

    private let characterFetcher: FetchCharacterDetailUseCase
    private var characterCancellable: Cancellable?

    init(characterFetcher: FetchCharacterDetailUseCase) {
        self.characterFetcher = characterFetcher
    }

    func start() {
        viewDelegate?.viewModelDidStartLoading(self)
        // TODO: Pass a character ID to the view model
        let query = FetchCharacterDetailQuery(characterID: 123456)
        // TODO: cache cancellable and cancel when view is gone
        loadCharacter(with: query)
    }
}

private extension CharacterDetailViewModel {

    func loadCharacter(with query: FetchCharacterDetailQuery) {
        characterCancellable?.cancel()
        characterCancellable = characterFetcher.fetch(query: query, completion: handleFetchCharacterResult)
    }

    func handleFetchCharacterResult(_ result: Result<PageInfo, Error>) {
        viewDelegate?.viewModelDidFinishLoading(self)
        switch result {
        case .success(let pageInfo):
            handleSuccess(with: pageInfo)
        case .failure(let error):
            handleFailure(with: error)
        }
    }

    func handleSuccess(with pageInfo: PageInfo) {
        // TODO: Implement
    }

    func handleFailure(with error: Error) {
        // TODO: Implement
    }
}
