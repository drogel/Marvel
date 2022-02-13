//
//  FetchCharactersUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

protocol FetchCharactersUseCase {
    func fetch(query: FetchCharactersQuery, completion: @escaping (FetchCharactersResult) -> Void) -> Cancellable?
}

struct FetchCharactersQuery {
    let offset: Int
}

typealias FetchCharactersUseCaseError = CharactersServiceError

typealias FetchCharactersResult = Result<PageData<CharacterData>, FetchCharactersUseCaseError>

class FetchCharactersServiceUseCase: FetchCharactersUseCase {
    private let service: CharactersService
    private let characterMapper: CharacterMapper
    private let pageMapper: PageMapper

    init(service: CharactersService, characterMapper: CharacterMapper, pageMapper: PageMapper) {
        self.service = service
        self.characterMapper = characterMapper
        self.pageMapper = pageMapper
    }

    func fetch(query: FetchCharactersQuery, completion: @escaping (FetchCharactersResult) -> Void) -> Cancellable? {
        service.characters(from: query.offset) { [weak self] result in
            guard let self = self else { return }
            self.handle(result, completion: completion)
        }
    }
}

private extension FetchCharactersServiceUseCase {
    func handle(_ result: CharactersServiceResult, completion: @escaping (FetchCharactersResult) -> Void) {
        switch result {
        case let .success(dataWrapper):
            completion(buildResult(from: dataWrapper))
        case let .failure(error):
            completion(.failure(error))
        }
    }

    func buildResult(from dataWrapper: DataWrapper<CharacterData>) -> FetchCharactersResult {
        guard let pageData = dataWrapper.data else { return .failure(.emptyData) }
        return .success(pageData)
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
