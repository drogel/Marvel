//
//  FetchCharacterDetailUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

protocol FetchCharacterDetailUseCase {
    func fetch(
        query: FetchCharacterDetailQuery,
        completion: @escaping (FetchCharacterDetailResult) -> Void
    ) -> Cancellable?
}

struct FetchCharacterDetailQuery {
    let characterID: Int
}

typealias FetchCharacterDetailUseCaseError = CharacterDetailServiceError

typealias FetchCharacterDetailResult = Result<ContentPage<Character>, FetchCharacterDetailUseCaseError>

class FetchCharacterDetailServiceUseCase: FetchCharacterDetailUseCase {
    private let service: CharacterDetailService
    private let characterMapper: CharacterMapper
    private let pageMapper: PageMapper

    init(service: CharacterDetailService, characterMapper: CharacterMapper, pageMapper: PageMapper) {
        self.service = service
        self.characterMapper = characterMapper
        self.pageMapper = pageMapper
    }

    func fetch(
        query: FetchCharacterDetailQuery,
        completion: @escaping (FetchCharacterDetailResult) -> Void
    ) -> Cancellable? {
        service.character(with: query.characterID) { [weak self] result in
            guard let self = self else { return }
            self.handle(result, completion: completion)
        }
    }
}

private extension FetchCharacterDetailServiceUseCase {
    func handle(_ result: CharacterDetailServiceResult, completion: @escaping (FetchCharacterDetailResult) -> Void) {
        switch result {
        case let .success(dataWrapper):
            completion(buildResult(from: dataWrapper))
        case let .failure(error):
            completion(.failure(error))
        }
    }

    func buildResult(from dataWrapper: DataWrapper<CharacterData>) -> FetchCharactersResult {
        guard let contentPage = mapToCharactersPage(dataWrapper.data) else { return .failure(.emptyData) }
        return .success(contentPage)
    }

    // TODO: Remove this duplication in FetchCharactersUseCase
    func mapToCharactersPage(_ pageData: PageData<CharacterData>?) -> ContentPage<Character>? {
        let characters = mapToCharacters(pageData?.results)
        guard let pageData = pageData,
              let pageDataCount = pageData.count,
              let pageInfo = pageMapper.mapToPageInfo(pageData),
              pageDataCount == characters.count
        else { return nil }
        return ContentPage(
            offset: pageInfo.offset,
            limit: pageInfo.limit,
            total: pageInfo.total,
            contents: characters
        )
    }

    func mapToCharacters(_ charactersData: [CharacterData]?) -> [Character] {
        guard let charactersData = charactersData else { return [] }
        return charactersData.compactMap(characterMapper.mapToCharacter)
    }
}
