//
//  FetchCharacterDetailUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

protocol FetchCharacterDetailUseCase {
    func fetch(query: FetchCharacterDetailQuery) async throws -> ContentPage<Character>
}

struct FetchCharacterDetailQuery {
    let characterID: Int
}

typealias FetchCharacterDetailUseCaseError = CharacterDetailServiceError

// TODO: Remove all kinds of results when we migrate to async await
typealias FetchCharacterDetailResult = Result<ContentPage<Character>, FetchCharacterDetailUseCaseError>

class FetchCharacterDetailServiceUseCase: FetchCharacterDetailUseCase {
    private let service: CharacterDetailService

    init(service: CharacterDetailService) {
        self.service = service
    }

    func fetch(query: FetchCharacterDetailQuery) async throws -> ContentPage<Character> {
        try await service.character(with: query.characterID)
    }
}
