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
    func viewModel(_ viewModel: CharacterDetailViewModelProtocol, didRetrieve characterDetail: CharacterDetailData)
    func viewModel(_ viewModel: CharacterDetailViewModelProtocol, didFailWithError message: String)
}

class CharacterDetailViewModel: CharacterDetailViewModelProtocol {

    private enum Messages {
        static let noSuchCharacter = "The character you are looking for can't be found in the database"
        static let noAPIKeys = "Your API keys to the Marvel API could not be found, or they are not valid. Add your own API keys in the environment variables of the project if you haven't already."
        static let noConnection = "It looks like you are not connected to the internet. Check your connection and try again."
    }

    weak var viewDelegate: CharacterDetailViewModelViewDelegate?

    private let characterFetcher: FetchCharacterDetailUseCase
    private let imageURLBuilder: ImageURLBuilder
    private let characterID: Int
    private var characterCancellable: Cancellable?

    init(characterFetcher: FetchCharacterDetailUseCase, characterID: Int, imageURLBuilder: ImageURLBuilder = ImageDataURLBuilder()) {
        self.characterFetcher = characterFetcher
        self.imageURLBuilder = imageURLBuilder
        self.characterID = characterID
    }

    func start() {
        viewDelegate?.viewModelDidStartLoading(self)
        let query = FetchCharacterDetailQuery(characterID: characterID)
        loadCharacter(with: query)
    }

    func dispose() {
        characterCancellable?.cancel()
    }
}

private extension CharacterDetailViewModel {

    func loadCharacter(with query: FetchCharacterDetailQuery) {
        characterCancellable?.cancel()
        characterCancellable = characterFetcher.fetch(query: query, completion: handleFetchCharacterResult)
    }

    func handleFetchCharacterResult(_ result: FetchCharacterDetailResult) {
        viewDelegate?.viewModelDidFinishLoading(self)
        switch result {
        case .success(let pageInfo):
            handleSuccess(with: pageInfo)
        case .failure(let error):
            handleFailure(with: error)
        }
    }

    func handleSuccess(with pageInfo: PageInfo) {
        guard let characterDetail = mapToCharacterDetail(characterData: pageInfo.results) else { return notifyNoCharacter() }
        viewDelegate?.viewModel(self, didRetrieve: characterDetail)
    }

    func handleFailure(with error: FetchCharacterDetailUseCaseError) {
        switch error {
        case .noConnection:
            viewDelegate?.viewModel(self, didFailWithError: Messages.noConnection)
        case .noSuchCharacter:
            notifyNoCharacter()
        case .unauthorized:
            viewDelegate?.viewModel(self, didFailWithError: Messages.noAPIKeys)
        }
    }

    func notifyNoCharacter() {
        viewDelegate?.viewModel(self, didFailWithError: Messages.noSuchCharacter)
    }

    func mapToCharacterDetail(characterData: [CharacterData]?) -> CharacterDetailData? {
        guard let firstCharacterData = characterData?.first,
              let name = firstCharacterData.name,
              let description = firstCharacterData.description
        else { return nil }
        let imageURL = imageURL(for: firstCharacterData)
        return CharacterDetailData(name: name, description: description, imageURL: imageURL)
    }

    func imageURL(for characterData: CharacterData) -> URL? {
        guard let thumbnail = characterData.thumbnail else { return nil }
        return imageURLBuilder.buildURL(from: thumbnail)
    }

    func fail(withError error: FetchCharacterDetailUseCaseError, completion: @escaping (FetchCharacterDetailResult) -> Void) {
        completion(.failure(error))
    }
}
