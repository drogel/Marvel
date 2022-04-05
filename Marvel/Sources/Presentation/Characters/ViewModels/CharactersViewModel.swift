//
//  CharactersViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Combine
import Foundation
import Domain

typealias CharactersViewModelState = Result<[CharacterCellModel], CharactersViewModelError>

protocol CharactersViewModelProtocol: ViewModel {
    var statePublisher: AnyPublisher<CharactersViewModelState, Never> { get }
    var loadingStatePublisher: AnyPublisher<LoadingState, Never> { get }
    func willDisplayCell(at indexPath: IndexPath) async
    func select(at indexPath: IndexPath)
}

protocol CharactersViewModelCoordinatorDelegate: AnyObject {
    func model(_ viewModel: CharactersViewModelProtocol, didSelectCharacterWith characterID: Int)
}

enum CharactersViewModelError: LocalizedError {
    case noCharacters
    case noAuthorization
    case noConnection

    var errorDescription: String? {
        switch self {
        case .noCharacters:
            return "server_not_responding".localized
        case .noAuthorization:
            return "api_keys_not_found".localized
        case .noConnection:
            return "no_internet".localized
        }
    }
}

class CharactersViewModel: CharactersViewModelProtocol {
    weak var coordinatorDelegate: CharactersViewModelCoordinatorDelegate?

    var statePublisher: AnyPublisher<CharactersViewModelState, Never> {
        $publishedState.eraseToAnyPublisher()
    }

    var loadingStatePublisher: AnyPublisher<LoadingState, Never> {
        $loadingState.eraseToAnyPublisher()
    }

    private var cellModels: [CharacterCellModel] {
        didSet {
            publishedState = .success(cellModels)
        }
    }

    @Published private var loadingState: LoadingState
    @Published private var publishedState: CharactersViewModelState
    private let charactersFetcher: FetchCharactersUseCase
    private let imageURLBuilder: ImageURLBuilder
    private let pager: Pager

    init(charactersFetcher: FetchCharactersUseCase, imageURLBuilder: ImageURLBuilder, pager: Pager) {
        self.charactersFetcher = charactersFetcher
        self.imageURLBuilder = imageURLBuilder
        self.pager = pager
        cellModels = []
        publishedState = .success(cellModels)
        loadingState = .idle
    }

    func start() async {
        loadingState = .loading
        await loadCharacters(with: startingQuery)
    }

    func select(at indexPath: IndexPath) {
        guard let data = cellModel(at: indexPath) else { return }
        coordinatorDelegate?.model(self, didSelectCharacterWith: data.identifier)
    }

    func willDisplayCell(at indexPath: IndexPath) async {
        guard shouldLoadMore(at: indexPath) else { return }
        await loadMore()
    }
}

private extension CharactersViewModel {
    var startingQuery: FetchCharactersQuery {
        FetchCharactersQuery(offset: 0)
    }

    func shouldLoadMore(at indexPath: IndexPath) -> Bool {
        pager.isAtEndOfCurrentPageWithMoreContent(indexPath.row)
    }

    func loadMore() async {
        guard cellModels.hasElements else { return await start() }
        let query = FetchCharactersQuery(offset: cellModels.count)
        await loadCharacters(with: query)
    }

    func cellModel(at indexPath: IndexPath) -> CharacterCellModel? {
        let row = indexPath.row
        guard cellModels.indices.contains(row) else { return nil }
        return cellModels[row]
    }

    func loadCharacters(with query: FetchCharactersQuery) async {
        do {
            defer { loadingState = .loaded }
            let contentPage = try await charactersFetcher.fetch(query: query)
            handleSuccess(with: contentPage)
        } catch let error as FetchCharactersUseCaseError {
            handleFailure(with: error)
        } catch {
            handleFailure(with: .emptyData)
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
        publishedState = .failure(viewModelError)
    }

    func viewModelError(for error: FetchCharacterDetailUseCaseError) -> CharactersViewModelError {
        switch error {
        case .noConnection:
            return .noConnection
        case .emptyData:
            return .noCharacters
        case .unauthorized:
            return .noAuthorization
        }
    }

    func mapToCells(characters: [Character]) -> [CharacterCellModel] {
        characters.map { character in
            CharacterCellModel(
                identifier: character.identifier,
                name: character.name,
                description: character.description,
                imageURL: buildImageURL(from: character)
            )
        }
    }

    func buildImageURL(from character: Character) -> URL? {
        imageURLBuilder.buildURL(from: character.image, variant: .detail)
    }

    func updateCells(using newCells: [CharacterCellModel]) {
        cellModels += newCells
    }
}
