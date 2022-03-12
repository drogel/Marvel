//
//  CharactersViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Combine
import Foundation

protocol CharactersViewModelProtocol: PresentationModel {
    var cellModelsPublisher: AnyPublisher<[CharacterCellModel], Never> { get }
    func willDisplayCell(at indexPath: IndexPath)
    func select(at indexPath: IndexPath)
}

protocol CharactersViewModelCoordinatorDelegate: AnyObject {
    func model(_ viewModel: CharactersViewModelProtocol, didSelectCharacterWith characterID: Int)
}

protocol CharactersViewModelViewDelegate: AnyObject {
    func modelDidStartLoading(_ viewModel: CharactersViewModelProtocol)
    func modelDidFinishLoading(_ viewModel: CharactersViewModelProtocol)
    func model(_ viewModel: CharactersViewModelProtocol, didFailWithError message: String)
}

enum CharactersViewModelError: LocalizedError {
    case noCharacters
    case noAPIKeys
    case noConnection

    var errorDescription: String? {
        switch self {
        case .noCharacters:
            return "server_not_responding".localized
        case .noAPIKeys:
            return "api_keys_not_found".localized
        case .noConnection:
            return "no_internet".localized
        }
    }
}

class CharactersViewModel: CharactersViewModelProtocol {
    weak var coordinatorDelegate: CharactersViewModelCoordinatorDelegate?
    weak var viewDelegate: CharactersViewModelViewDelegate?

    var cellModelsPublisher: AnyPublisher<[CharacterCellModel], Never> { cellModelsSubject.eraseToAnyPublisher() }

    private var cellModelsSubject: CurrentValueSubject<[CharacterCellModel], Never>
    private let charactersFetcher: FetchCharactersUseCase
    private let imageURLBuilder: ImageURLBuilder
    private let pager: Pager
    private var charactersDisposable: Disposable?

    init(charactersFetcher: FetchCharactersUseCase, imageURLBuilder: ImageURLBuilder, pager: Pager) {
        self.charactersFetcher = charactersFetcher
        self.imageURLBuilder = imageURLBuilder
        self.pager = pager
        cellModelsSubject = CurrentValueSubject<[CharacterCellModel], Never>([])
    }

    func start() {
        viewDelegate?.modelDidStartLoading(self)
        loadCharacters(with: startingQuery)
    }

    func select(at indexPath: IndexPath) {
        guard let data = cellModel(at: indexPath) else { return }
        coordinatorDelegate?.model(self, didSelectCharacterWith: data.identifier)
    }

    func willDisplayCell(at indexPath: IndexPath) {
        guard shouldLoadMore(at: indexPath) else { return }
        loadMore()
    }

    func dispose() {
        charactersDisposable?.dispose()
    }
}

private extension CharactersViewModel {
    var startingQuery: FetchCharactersQuery {
        FetchCharactersQuery(offset: 0)
    }

    var cellModels: [CharacterCellModel] {
        cellModelsSubject.value
    }

    func shouldLoadMore(at indexPath: IndexPath) -> Bool {
        pager.isAtEndOfCurrentPageWithMoreContent(indexPath.row)
    }

    func loadMore() {
        guard cellModels.hasElements else { return start() }
        let query = FetchCharactersQuery(offset: cellModels.count)
        loadCharacters(with: query)
    }

    func cellModel(at indexPath: IndexPath) -> CharacterCellModel? {
        let row = indexPath.row
        guard cellModels.indices.contains(row) else { return nil }
        return cellModels[row]
    }

    func loadCharacters(with query: FetchCharactersQuery) {
        charactersDisposable?.dispose()
        charactersDisposable = charactersFetcher.fetch(query: query) { [weak self] result in
            self?.handleFetchCharactersResult(result)
        }
    }

    func handleFetchCharactersResult(_ result: FetchCharactersResult) {
        viewDelegate?.modelDidFinishLoading(self)
        switch result {
        case let .success(contentPage):
            handleSuccess(with: contentPage)
        case let .failure(error):
            handleFailure(with: error)
        }
    }

    func handleSuccess(with contentPage: ContentPage<Character>) {
        let newCells = mapToCells(characters: contentPage.contents)
        guard newCells.hasElements else { return }
        updateCells(using: newCells)
        pager.update(currentPage: contentPage)
    }

    func handleFailure(with error: FetchCharacterDetailUseCaseError) {
        let viewModelError = viewModelError(for: error)
        viewDelegate?.model(self, didFailWithError: viewModelError.localizedDescription)
    }

    func viewModelError(for error: FetchCharacterDetailUseCaseError) -> CharactersViewModelError {
        switch error {
        case .noConnection:
            return .noConnection
        case .emptyData:
            return .noCharacters
        case .unauthorized:
            return .noAPIKeys
        }
    }

    func mapToCells(characters: [Character]) -> [CharacterCellModel] {
        characters.map { character in
            let imageURL = buildImageURL(from: character)
            return CharacterCellModel(
                identifier: character.identifier,
                name: character.name,
                description: character.description,
                imageURL: imageURL
            )
        }
    }

    func buildImageURL(from character: Character) -> URL? {
        imageURLBuilder.buildURL(from: character.image, variant: .detail)
    }

    func updateCells(using newCells: [CharacterCellModel]) {
        cellModelsSubject.value += newCells
    }
}
