//
//  CharacterDetailInfoViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

protocol CharacterDetailInfoViewModelProtocol: ViewModel {
    var imageCellData: CharacterImageData? { get }
    var infoCellData: CharacterInfoData? { get }
}

protocol CharacterDetailInfoViewModelViewDelegate: AnyObject {
    func viewModelDidStartLoading(_ viewModel: CharacterDetailInfoViewModelProtocol)
    func viewModelDidFinishLoading(_ viewModel: CharacterDetailInfoViewModelProtocol)
    func viewModelDidRetrieveData(_ viewModel: CharacterDetailInfoViewModelProtocol)
    func viewModel(_ viewModel: CharacterDetailInfoViewModelProtocol, didFailWithError message: String)
}

class CharacterDetailInfoViewModel: CharacterDetailInfoViewModelProtocol {
    private enum Messages {
        static let noSuchCharacter = "character_not_found".localized
        static let noAPIKeys = "api_keys_not_found".localized
        static let noConnection = "no_internet".localized
    }

    weak var viewDelegate: CharacterDetailInfoViewModelViewDelegate?

    var imageCellData: CharacterImageData? {
        characterDetailData?.image
    }

    var infoCellData: CharacterInfoData? {
        characterDetailData?.info
    }

    private let characterFetcher: FetchCharacterDetailUseCase
    private let imageURLBuilder: ImageURLBuilder
    private let characterID: Int
    private var characterDetailData: CharacterDetailData?
    private var characterCancellable: Cancellable?

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
        viewDelegate?.viewModelDidStartLoading(self)
        let query = FetchCharacterDetailQuery(characterID: characterID)
        loadCharacter(with: query)
    }

    func dispose() {
        characterCancellable?.cancel()
    }
}

private extension CharacterDetailInfoViewModel {
    func loadCharacter(with query: FetchCharacterDetailQuery) {
        characterCancellable?.cancel()
        characterCancellable = characterFetcher.fetch(query: query, completion: handleFetchCharacterResult)
    }

    func handleFetchCharacterResult(_ result: FetchCharacterDetailResult) {
        viewDelegate?.viewModelDidFinishLoading(self)
        switch result {
        case let .success(pageInfo):
            handleSuccess(with: pageInfo)
        case let .failure(error):
            handleFailure(with: error)
        }
    }

    func handleSuccess(with pageInfo: PageInfo<CharacterData>) {
        guard let characterDetail = mapToCharacterDetail(characterData: pageInfo.results) else { return }
        characterDetailData = characterDetail
        viewDelegate?.viewModelDidRetrieveData(self)
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
            return Messages.noSuchCharacter
        case .unauthorized:
            return Messages.noAPIKeys
        }
    }

    func mapToCharacterDetail(characterData: [CharacterData]?) -> CharacterDetailData? {
        guard let firstCharacterData = characterData?.first,
              let characterInfoData = infoData(from: firstCharacterData)
        else { return nil }
        let characterImageData = imageData(from: firstCharacterData)
        return CharacterDetailData(image: characterImageData, info: characterInfoData)
    }

    func imageData(from characterData: CharacterData) -> CharacterImageData {
        CharacterImageData(imageURL: imageURL(for: characterData))
    }

    func infoData(from characterData: CharacterData) -> CharacterInfoData? {
        guard let name = characterData.name, let description = characterData.description else { return nil }
        return CharacterInfoData(name: name, description: description)
    }

    func imageURL(for characterData: CharacterData) -> URL? {
        guard let thumbnail = characterData.thumbnail else { return nil }
        return imageURLBuilder.buildURL(from: thumbnail)
    }
}
