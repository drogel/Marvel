//
//  CharactersPresentationModel.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Foundation

protocol CharactersPresentationModelProtocol: PresentationModel {
    var numberOfItems: Int { get }
    var cellModels: [CharacterCellModel] { get }
    func willDisplayCell(at indexPath: IndexPath)
    func select(at indexPath: IndexPath)
    func cellModel(at indexPath: IndexPath) -> CharacterCellModel?
}

protocol CharactersPresentationModelCoordinatorDelegate: AnyObject {
    func model(_ presentationModel: CharactersPresentationModelProtocol, didSelectCharacterWith characterID: Int)
}

protocol CharactersPresentationModelViewDelegate: AnyObject {
    func modelDidStartLoading(_ presentationModel: CharactersPresentationModelProtocol)
    func modelDidFinishLoading(_ presentationModel: CharactersPresentationModelProtocol)
    func modelDidUpdateItems(_ presentationModel: CharactersPresentationModelProtocol)
    func model(_ presentationModel: CharactersPresentationModelProtocol, didFailWithError message: String)
}

class CharactersPresentationModel: CharactersPresentationModelProtocol {
    private enum Messages {
        static let noCharacters = "server_not_responding".localized
        static let noAPIKeys = "api_keys_not_found".localized
        static let noConnection = "no_internet".localized
    }

    weak var coordinatorDelegate: CharactersPresentationModelCoordinatorDelegate?
    weak var viewDelegate: CharactersPresentationModelViewDelegate?

    var numberOfItems: Int {
        cellModels.count
    }

    private(set) var cellModels: [CharacterCellModel]

    private let charactersFetcher: FetchCharactersUseCase
    private let imageURLBuilder: ImageURLBuilder
    private let pager: Pager
    private var charactersCancellable: Cancellable?

    init(charactersFetcher: FetchCharactersUseCase, imageURLBuilder: ImageURLBuilder, pager: Pager) {
        self.charactersFetcher = charactersFetcher
        self.imageURLBuilder = imageURLBuilder
        self.pager = pager
        cellModels = []
    }

    func start() {
        viewDelegate?.modelDidStartLoading(self)
        loadCharacters(with: startingQuery)
    }

    func cellModel(at indexPath: IndexPath) -> CharacterCellModel? {
        let row = indexPath.row
        guard cellModels.indices.contains(row) else { return nil }
        return cellModels[row]
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
        charactersCancellable?.cancel()
    }
}

private extension CharactersPresentationModel {
    var startingQuery: FetchCharactersQuery {
        FetchCharactersQuery(offset: 0)
    }

    func shouldLoadMore(at indexPath: IndexPath) -> Bool {
        pager.isAtEndOfCurrentPageWithMoreContent(indexPath.row)
    }

    func loadMore() {
        guard cellModels.hasElements else { return start() }
        let query = FetchCharactersQuery(offset: cellModels.count)
        loadCharacters(with: query)
    }

    func loadCharacters(with query: FetchCharactersQuery) {
        charactersCancellable?.cancel()
        charactersCancellable = charactersFetcher.fetch(query: query, completion: handleFetchCharactersResult)
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
        let message = message(for: error)
        viewDelegate?.model(self, didFailWithError: message)
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
        cellModels.append(contentsOf: newCells)
        viewDelegate?.modelDidUpdateItems(self)
    }
}
