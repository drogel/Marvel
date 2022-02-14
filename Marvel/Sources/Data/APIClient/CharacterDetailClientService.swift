//
//  CharacterDetailClientService.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

class CharacterDetailClientService: CharacterDetailService {
    private let charactersPath = MarvelAPIPaths.characters.rawValue
    private let client: NetworkService
    private let resultHandler: ResultHandler
    private let characterMapper: CharacterMapper
    private let pageMapper: PageMapper

    init(
        client: NetworkService,
        resultHandler: ResultHandler,
        characterMapper: CharacterMapper,
        pageMapper: PageMapper
    ) {
        self.client = client
        self.resultHandler = resultHandler
        self.characterMapper = characterMapper
        self.pageMapper = pageMapper
    }

    func character(with identifier: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Cancellable? {
        client.request(endpoint: components(for: identifier)) { [weak self] result in
            self?.resultHandler.handle(result: result) { handlerResult in
                self?.completeWithServiceResult(handlerResult, completion: completion)
            }
        }
    }
}

private extension CharacterDetailClientService {
    func components(for identifier: Int) -> RequestComponents {
        let characterID = String(identifier)
        return RequestComponents().appendingPathComponents([charactersPath, characterID])
    }

    func completeWithServiceResult(
        _ handlerResult: DataServiceResult<CharacterData>,
        completion: @escaping (CharacterDetailServiceResult) -> Void
    ) {
        switch handlerResult {
        case let .success(dataWrapper):
            completeHandlerSuccess(dataWrapper: dataWrapper, completion: completion)
        case let .failure(error):
            completion(.failure(error))
        }
    }

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
