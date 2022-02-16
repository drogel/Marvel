//
//  CharactersClientService.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

class CharactersClientService: CharactersService {
    private let charactersPath = MarvelAPIPaths.characters.rawValue
    private let client: NetworkService
    private let resultHandler: NetworkResultHandler
    private let characterMapper: CharacterMapper
    private let pageMapper: PageMapper

    init(
        client: NetworkService,
        resultHandler: NetworkResultHandler,
        characterMapper: CharacterMapper,
        pageMapper: PageMapper
    ) {
        self.client = client
        self.resultHandler = resultHandler
        self.characterMapper = characterMapper
        self.pageMapper = pageMapper
    }

    func characters(from offset: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Cancellable? {
        client.request(endpoint: components(for: offset)) { [weak self] result in
            self?.resultHandler.handle(result: result) { handlerResult in
                self?.completeWithServiceResult(handlerResult, completion: completion)
            }
        }
    }
}

private extension CharactersClientService {
    func components(for offset: Int) -> RequestComponents {
        RequestComponents(path: charactersPath).withOffsetQuery(offset)
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
