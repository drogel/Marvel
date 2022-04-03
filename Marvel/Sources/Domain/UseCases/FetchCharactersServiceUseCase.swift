//
//  FetchCharactersUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

protocol FetchCharactersUseCase {
    func fetch(query: FetchCharactersQuery) async throws -> ContentPage<Character>
}

struct FetchCharactersQuery {
    let offset: Int
}

typealias FetchCharactersUseCaseError = CharactersServiceError

class FetchCharactersServiceUseCase: FetchCharactersUseCase {
    private let service: CharactersService

    init(service: CharactersService) {
        self.service = service
    }

    func fetch(query: FetchCharactersQuery) async throws -> ContentPage<Character> {
        try await service.characters(from: query.offset)
    }
}
