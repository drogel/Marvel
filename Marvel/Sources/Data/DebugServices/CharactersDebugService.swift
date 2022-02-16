//
//  CharactersDebugService.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

class CharactersDebugService: CharactersService {
    private let charactersFileName: DebugDataFileName = .charactersFileName
    private let dataLoader: DataLoaderDebugService
    private let characterMapper: CharacterMapper
    private let pageMapper: PageMapper

    init(dataLoader: JsonDataLoader, characterMapper: CharacterMapper, pageMapper: PageMapper) {
        self.dataLoader = JsonDataLoaderDebugService(dataLoader: dataLoader, fileName: charactersFileName)
        self.characterMapper = characterMapper
        self.pageMapper = pageMapper
    }

    func characters(from _: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Cancellable? {
        dataLoader.loadData { [weak self] result in
            self?.completeWithServiceResult(result, completion: completion)
        }
    }
}

private extension CharactersDebugService {
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
