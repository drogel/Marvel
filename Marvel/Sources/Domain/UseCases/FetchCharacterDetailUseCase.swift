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
    ) -> Disposable?
}

struct FetchCharacterDetailQuery {
    let characterID: Int
}

typealias FetchCharacterDetailUseCaseError = CharacterDetailServiceError

typealias FetchCharacterDetailResult = Result<ContentPage<Character>, FetchCharacterDetailUseCaseError>

class FetchCharacterDetailServiceUseCase: FetchCharacterDetailUseCase {
    private let service: CharacterDetailService

    init(service: CharacterDetailService) {
        self.service = service
    }

    func fetch(
        query: FetchCharacterDetailQuery,
        completion: @escaping (FetchCharacterDetailResult) -> Void
    ) -> Disposable? {
        service.character(with: query.characterID, completion: completion)
    }
}
