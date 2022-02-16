//
//  CharacterDataResultHandler.swift
//  Marvel
//
//  Created by Diego Rogel on 16/2/22.
//

import Foundation

protocol CharacterDataResultHandler {
    func completeWithServiceResult(
        _ handlerResult: DataServiceResult<CharacterData>,
        completion: @escaping (Result<ContentPage<Character>, DataServiceError>) -> Void
    )
}

class CharacterDataServiceResultHandler: CharacterDataResultHandler {
    private let characterMapper: CharacterMapper
    private let pageMapper: PageMapper

    init(characterMapper: CharacterMapper, pageMapper: PageMapper) {
        self.characterMapper = characterMapper
        self.pageMapper = pageMapper
    }

    func completeWithServiceResult(
        _ handlerResult: DataServiceResult<CharacterData>,
        completion: @escaping (Result<ContentPage<Character>, CharactersServiceError>) -> Void
    ) {
        switch handlerResult {
        case let .success(dataWrapper):
            completeHandlerSuccess(dataWrapper: dataWrapper, completion: completion)
        case let .failure(error):
            completion(.failure(error))
        }
    }
}

private extension CharacterDataServiceResultHandler {
    func completeHandlerSuccess(
        dataWrapper: DataWrapper<CharacterData>,
        completion: @escaping (CharacterDetailServiceResult) -> Void
    ) {
        guard let contentPage = mapToCharactersPage(dataWrapper.data) else {
            completion(.failure(.emptyData))
            return
        }
        completion(.success(contentPage))
    }

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
