//
//  CharacterInfoPresentationModel.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Combine
import Foundation

protocol CharacterInfoPresentationModelProtocol: PresentationModel {
    var infoStatePublisher: AnyPublisher<CharacterInfoViewModelState, Never> { get }
    var loadingStatePublisher: AnyPublisher<LoadingState, Never> { get }
}

typealias CharacterInfoViewModelState = Result<CharacterInfoModel?, CharacterInfoViewModelError>

enum CharacterInfoViewModelError: LocalizedError {
    case noSuchCharacter
    case noAuthorization
    case noConnection

    var errorDescription: String? {
        switch self {
        case .noSuchCharacter:
            return "character_not_found".localized
        case .noAuthorization:
            return "api_keys_not_found".localized
        case .noConnection:
            return "no_internet".localized
        }
    }
}

class CharacterInfoPresentationModel: CharacterInfoPresentationModelProtocol {
    var infoStatePublisher: AnyPublisher<CharacterInfoViewModelState, Never> {
        $publishedState.eraseToAnyPublisher()
    }

    var loadingStatePublisher: AnyPublisher<LoadingState, Never> {
        $loadingState.eraseToAnyPublisher()
    }

    private var characterInfoModel: CharacterInfoModel? {
        didSet {
            publishedState = .success(characterInfoModel)
        }
    }

    @Published private var publishedState: CharacterInfoViewModelState
    @Published private var loadingState: LoadingState
    private let characterFetcher: FetchCharacterDetailUseCase
    private let imageURLBuilder: ImageURLBuilder
    private let characterID: Int
    private var characterDisposable: Disposable?

    init(
        characterFetcher: FetchCharacterDetailUseCase,
        characterID: Int,
        imageURLBuilder: ImageURLBuilder
    ) {
        self.characterFetcher = characterFetcher
        self.imageURLBuilder = imageURLBuilder
        self.characterID = characterID
        publishedState = .success(characterInfoModel)
        loadingState = .idle
    }

    func start() {
        loadingState = .loading
        let query = FetchCharacterDetailQuery(characterID: characterID)
        loadCharacter(with: query)
    }

    func dispose() {
        characterDisposable?.dispose()
    }
}

private extension CharacterInfoPresentationModel {
    func loadCharacter(with query: FetchCharacterDetailQuery) {
        characterDisposable?.dispose()
        characterDisposable = characterFetcher.fetch(query: query) { [weak self] result in
            self?.handleFetchCharacterResult(result)
        }
    }

    func handleFetchCharacterResult(_ result: FetchCharacterDetailResult) {
        loadingState = .loaded
        switch result {
        case let .success(contentPage):
            handleSuccess(with: contentPage)
        case let .failure(error):
            handleFailure(with: error)
        }
    }

    func handleSuccess(with contentPage: ContentPage<Character>) {
        guard let characterInfo = mapToCharacterInfo(characters: contentPage.contents) else { return }
        characterInfoModel = characterInfo
    }

    func handleFailure(with error: FetchCharacterDetailUseCaseError) {
        let viewModelError = viewModelError(for: error)
        publishedState = .failure(viewModelError)
    }

    func viewModelError(for error: FetchCharacterDetailUseCaseError) -> CharacterInfoViewModelError {
        switch error {
        case .noConnection:
            return .noConnection
        case .emptyData:
            return .noSuchCharacter
        case .unauthorized:
            return .noAuthorization
        }
    }

    func mapToCharacterInfo(characters: [Character]) -> CharacterInfoModel? {
        guard let firstCharacter = characters.first else { return nil }
        let characterInfoData = infoData(from: firstCharacter)
        let characterImageModel = imageData(from: firstCharacter)
        return CharacterInfoModel(image: characterImageModel, description: characterInfoData)
    }

    func imageData(from character: Character) -> CharacterImageModel {
        CharacterImageModel(imageURL: imageURL(for: character))
    }

    func infoData(from character: Character) -> CharacterDescriptionModel {
        CharacterDescriptionModel(name: character.name, description: character.description)
    }

    func imageURL(for character: Character) -> URL? {
        imageURLBuilder.buildURL(from: character.image)
    }
}
