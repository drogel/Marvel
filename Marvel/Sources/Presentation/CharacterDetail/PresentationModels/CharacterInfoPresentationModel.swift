//
//  CharacterInfoPresentationModel.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Combine
import Foundation

protocol CharacterInfoPresentationModelProtocol: PresentationModel {
    var imageCellData: CharacterImageModel? { get }
    var infoCellData: CharacterDescriptionModel? { get }
}

protocol CharacterInfoPresentationModelViewDelegate: AnyObject {
    func modelDidStartLoading(_ presentationModel: CharacterInfoPresentationModelProtocol)
    func modelDidFinishLoading(_ presentationModel: CharacterInfoPresentationModelProtocol)
    func modelDidRetrieveData(_ presentationModel: CharacterInfoPresentationModelProtocol)
    func model(_ presentationModel: CharacterInfoPresentationModelProtocol, didFailWithError message: String)
}

typealias CharacterInfoViewModelState = Result<CharacterInfoModel, CharacterInfoViewModelError>

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
    weak var viewDelegate: CharacterInfoPresentationModelViewDelegate?

    var imageCellData: CharacterImageModel? {
        characterDetailModel?.image
    }

    var infoCellData: CharacterDescriptionModel? {
        characterDetailModel?.info
    }

    private let characterFetcher: FetchCharacterDetailUseCase
    private let imageURLBuilder: ImageURLBuilder
    private let characterID: Int
    private var characterDetailModel: CharacterInfoModel?
    private var characterDisposable: Disposable?

    init(
        characterFetcher: FetchCharacterDetailUseCase,
        characterID: Int,
        imageURLBuilder: ImageURLBuilder
    ) {
        self.characterFetcher = characterFetcher
        self.imageURLBuilder = imageURLBuilder
        self.characterID = characterID
    }

    func start() {
        viewDelegate?.modelDidStartLoading(self)
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
        characterDisposable = characterFetcher.fetch(query: query, completion: handleFetchCharacterResult)
    }

    func handleFetchCharacterResult(_ result: FetchCharacterDetailResult) {
        viewDelegate?.modelDidFinishLoading(self)
        switch result {
        case let .success(contentPage):
            handleSuccess(with: contentPage)
        case let .failure(error):
            handleFailure(with: error)
        }
    }

    func handleSuccess(with contentPage: ContentPage<Character>) {
        guard let characterDetail = mapToCharacterDetail(characters: contentPage.contents) else { return }
        characterDetailModel = characterDetail
        viewDelegate?.modelDidRetrieveData(self)
    }

    func handleFailure(with error: FetchCharacterDetailUseCaseError) {
        let message = message(for: error)
        viewDelegate?.model(self, didFailWithError: message)
    }

    func message(for error: FetchCharacterDetailUseCaseError) -> String {
        switch error {
        case .noConnection:
            return CharacterInfoViewModelError.noConnection.localizedDescription
        case .emptyData:
            return CharacterInfoViewModelError.noSuchCharacter.localizedDescription
        case .unauthorized:
            return CharacterInfoViewModelError.noAuthorization.localizedDescription
        }
    }

    func mapToCharacterDetail(characters: [Character]) -> CharacterInfoModel? {
        guard let firstCharacter = characters.first else { return nil }
        let characterInfoData = infoData(from: firstCharacter)
        let characterImageModel = imageData(from: firstCharacter)
        return CharacterInfoModel(image: characterImageModel, info: characterInfoData)
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
