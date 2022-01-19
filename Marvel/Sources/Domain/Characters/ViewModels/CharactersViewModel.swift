//
//  CharactersViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Foundation

protocol CharactersViewModelProtocol: ViewModel {
    func select(itemAt indexPath: IndexPath)
}

protocol CharactersViewModelCoordinatorDelegate: AnyObject {
    func viewModel(_ viewModel: CharactersViewModelProtocol, didSelectItemAt indexPath: IndexPath)
}

class CharactersViewModel: CharactersViewModelProtocol {

    weak var coordinatorDelegate: CharactersViewModelCoordinatorDelegate?

    private let charactersFetcher: FetchCharactersUseCaseProtocol

    init(charactersFetcher: FetchCharactersUseCaseProtocol) {
        self.charactersFetcher = charactersFetcher
    }

    func start() {
        // TODO: Create queries that take into account the offset for pagination
        let query = FetchCharactersQuery(offset: 0)
        // TODO: Cache cancellable
        let _ = charactersFetcher.fetch(query: query, completion: handleFetchCharactersResult)
    }

    func select(itemAt indexPath: IndexPath) {
        coordinatorDelegate?.viewModel(self, didSelectItemAt: indexPath)
    }

    private func handleFetchCharactersResult(_ result: Result<PageInfo, Error>) {
        // TODO: Implement
    }
}
