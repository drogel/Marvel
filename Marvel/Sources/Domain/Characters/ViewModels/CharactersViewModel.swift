//
//  CharactersViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Foundation

protocol CharactersViewModelProtocol: ViewModel {
    var numberOfItems: Int { get }
    func willDisplayCell(at indexPath: IndexPath)
    func select(at indexPath: IndexPath)
    func cellData(at indexPath: IndexPath) -> CharacterCellData?
}

protocol CharactersViewModelCoordinatorDelegate: AnyObject {
    func viewModel(_ viewModel: CharactersViewModelProtocol, didSelectCharacterWith characterID: Int)
}

protocol CharactersViewModelViewDelegate: AnyObject {
    func viewModelDidStartLoading(_ viewModel: CharactersViewModelProtocol)
    func viewModelDidFinishLoading(_ viewModel: CharactersViewModelProtocol)
    func viewModelDidUpdateItems(_ viewModel: CharactersViewModelProtocol)
    func viewModel(_ viewModel: CharactersViewModelProtocol, didFailWithError message: String)
}

class CharactersViewModel: CharactersViewModelProtocol {
    private enum Messages {
        static let noCharacters = "server_not_responding".localized
        static let noAPIKeys = "api_keys_not_found".localized
        static let noConnection = "no_internet".localized
    }

    weak var coordinatorDelegate: CharactersViewModelCoordinatorDelegate?
    weak var viewDelegate: CharactersViewModelViewDelegate?

    var numberOfItems: Int {
        return cells.count
    }

    private let charactersFetcher: FetchCharactersUseCase
    private let imageURLBuilder: ImageURLBuilder
    private var cells: [CharacterCellData]
    private var charactersCancellable: Cancellable?

    init(charactersFetcher: FetchCharactersUseCase, imageURLBuilder: ImageURLBuilder = ImageDataURLBuilder()) {
        self.charactersFetcher = charactersFetcher
        self.imageURLBuilder = imageURLBuilder
        cells = []
    }

    func start() {
        viewDelegate?.viewModelDidStartLoading(self)
        loadCharacters(with: startingQuery)
    }

    func cellData(at indexPath: IndexPath) -> CharacterCellData? {
        let row = indexPath.row
        guard cells.indices.contains(row) else { return nil }
        return cells[row]
    }

    func select(at indexPath: IndexPath) {
        guard let data = cellData(at: indexPath) else { return }
        coordinatorDelegate?.viewModel(self, didSelectCharacterWith: data.identifier)
    }

    func willDisplayCell(at indexPath: IndexPath) {
        guard isLastCell(at: indexPath) else { return }
        loadMore()
    }

    func dispose() {
        charactersCancellable?.cancel()
    }
}

private extension CharactersViewModel {
    var startingQuery: FetchCharactersQuery {
        FetchCharactersQuery(offset: 0)
    }

    func isLastCell(at indexPath: IndexPath) -> Bool {
        indexPath.row == numberOfItems - 1
    }

    func loadMore() {
        guard cells.hasElements else { return start() }
        let query = FetchCharactersQuery(offset: cells.count)
        loadCharacters(with: query)
    }

    func loadCharacters(with query: FetchCharactersQuery) {
        charactersCancellable?.cancel()
        charactersCancellable = charactersFetcher.fetch(query: query, completion: handleFetchCharactersResult)
    }

    func handleFetchCharactersResult(_ result: FetchCharactersResult) {
        viewDelegate?.viewModelDidFinishLoading(self)
        switch result {
        case let .success(pageInfo):
            handleSuccess(with: pageInfo)
        case let .failure(error):
            handleFailure(with: error)
        }
    }

    func handleSuccess(with pageInfo: PageInfo) {
        guard let newCells = mapToCells(characterData: pageInfo.results), newCells.hasElements else { return }
        updateCells(using: newCells)
    }

    func handleFailure(with error: FetchCharacterDetailUseCaseError) {
        let message = message(for: error)
        viewDelegate?.viewModel(self, didFailWithError: message)
    }

    func message(for error: FetchCharacterDetailUseCaseError) -> String {
        switch error {
        case .noConnection:
            return Messages.noConnection
        case .emptyData:
            return Messages.noCharacters
        case .unauthorized:
            return Messages.noAPIKeys
        }
    }

    func mapToCells(characterData: [CharacterData]?) -> [CharacterCellData]? {
        characterData?.compactMap { data in
            guard let identifier = data.identifier,
                  let name = data.name,
                  let description = data.description
            else { return nil }
            let imageURL = buildImageURL(from: data)
            return CharacterCellData(identifier: identifier, name: name, description: description, imageURL: imageURL)
        }
    }

    func buildImageURL(from data: CharacterData) -> URL? {
        guard let imageData = data.thumbnail else { return nil }
        return imageURLBuilder.buildURL(from: imageData)
    }

    func updateCells(using newCells: [CharacterCellData]) {
        cells.append(contentsOf: newCells)
        viewDelegate?.viewModelDidUpdateItems(self)
    }
}
