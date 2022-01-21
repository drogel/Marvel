//
//  CharactersViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Foundation

protocol CharactersViewModelProtocol: ViewModel {
    var numberOfItems: Int { get }
    func select(itemAt indexPath: IndexPath)
    func cellData(at indexPath: IndexPath) -> CharacterCellData?
}

protocol CharactersViewModelCoordinatorDelegate: AnyObject {
    func viewModel(_ viewModel: CharactersViewModelProtocol, didSelectItemAt indexPath: IndexPath)
}

protocol CharactersViewModelViewDelegate: AnyObject {
    func viewModelDidStartLoading(_ viewModel: CharactersViewModelProtocol)
    func viewModelDidFinishLoading(_ viewModel: CharactersViewModelProtocol)
    func viewModelDidUpdateItems(_ viewModel: CharactersViewModelProtocol)
}

class CharactersViewModel: CharactersViewModelProtocol {

    weak var coordinatorDelegate: CharactersViewModelCoordinatorDelegate?
    weak var viewDelegate: CharactersViewModelViewDelegate?

    var numberOfItems: Int {
        guard let cells = cells else { return 0 }
        return cells.count
    }

    private let charactersFetcher: FetchCharactersUseCase
    private var cells: [CharacterCellData]?

    init(charactersFetcher: FetchCharactersUseCase) {
        self.charactersFetcher = charactersFetcher
    }

    func start() {
        viewDelegate?.viewModelDidStartLoading(self)
        // TODO: Create queries that take into account the offset for pagination
        let query = FetchCharactersQuery(offset: 0)
        // TODO: Cache cancellable, cancel when view is gone
        let _ = charactersFetcher.fetch(query: query, completion: handleFetchCharactersResult)
    }

    func cellData(at indexPath: IndexPath) -> CharacterCellData? {
        let row = indexPath.row
        guard let cells = cells, cells.indices.contains(row) else { return nil }
        return cells[row]
    }

    func select(itemAt indexPath: IndexPath) {
        coordinatorDelegate?.viewModel(self, didSelectItemAt: indexPath)
    }
}

private extension CharactersViewModel {

    func handleFetchCharactersResult(_ result: Result<PageInfo, Error>) {
        viewDelegate?.viewModelDidFinishLoading(self)
        switch result {
        case .success(let pageInfo):
            handleSuccess(with: pageInfo)
        case .failure(let error):
            handleFailure(with: error)
        }
    }

    func handleSuccess(with pageInfo: PageInfo) {
        cells = mapToCells(characterData: pageInfo.results)
        viewDelegate?.viewModelDidUpdateItems(self)
    }

    func handleFailure(with error: Error) {
        // TODO: Implement
    }

    func mapToCells(characterData: [CharacterData]?) -> [CharacterCellData]? {
        characterData?.compactMap{ data in
            guard let name = data.name, let description = data.description else { return nil }
            return CharacterCellData(name: name, description: description)
        }
    }
}
