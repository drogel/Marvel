//
//  CharacterInfoPresentationModel.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

protocol CharacterInfoPresentationModelProtocol: PresentationModel {
    var imageCellData: CharacterImageModel? { get }
    var infoCellData: CharacterInfoModel? { get }
}

protocol CharacterInfoPresentationModelViewDelegate: AnyObject {
    func modelDidStartLoading(_ presentationModel: CharacterInfoPresentationModelProtocol)
    func modelDidFinishLoading(_ presentationModel: CharacterInfoPresentationModelProtocol)
    func modelDidRetrieveData(_ presentationModel: CharacterInfoPresentationModelProtocol)
    func model(_ presentationModel: CharacterInfoPresentationModelProtocol, didFailWithError message: String)
}

class CharacterInfoPresentationModel: CharacterInfoPresentationModelProtocol {
    private enum Messages {
        static let noSuchCharacter = "character_not_found".localized
        static let noAPIKeys = "api_keys_not_found".localized
        static let noConnection = "no_internet".localized
    }

    weak var viewDelegate: CharacterInfoPresentationModelViewDelegate?

    var imageCellData: CharacterImageModel? {
        characterDetailData?.image
    }

    var infoCellData: CharacterInfoModel? {
        characterDetailData?.info
    }

    private let characterFetcher: FetchCharacterDetailUseCase
    private let imageURLBuilder: ImageURLBuilder
    private let characterID: Int
    private var characterDetailData: CharacterDetailModel?
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
        characterDetailData = characterDetail
        viewDelegate?.modelDidRetrieveData(self)
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
            return Messages.noSuchCharacter
        case .unauthorized:
            return Messages.noAPIKeys
        }
    }

    func mapToCharacterDetail(characters: [Character]) -> CharacterDetailModel? {
        guard let firstCharacter = characters.first else { return nil }
        let characterInfoData = infoData(from: firstCharacter)
        let characterImageModel = imageData(from: firstCharacter)
        return CharacterDetailModel(image: characterImageModel, info: characterInfoData)
    }

    func imageData(from character: Character) -> CharacterImageModel {
        CharacterImageModel(imageURL: imageURL(for: character))
    }

    func infoData(from character: Character) -> CharacterInfoModel {
        CharacterInfoModel(name: character.name, description: character.description)
    }

    func imageURL(for character: Character) -> URL? {
        imageURLBuilder.buildURL(from: character.image)
    }
}
