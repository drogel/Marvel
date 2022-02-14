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
        service.character(with: query.characterID, completion: completion)
    }
}
