//
//  FetchCharacterDetailUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

public protocol FetchCharacterDetailUseCase {
    func fetch(query: FetchCharacterDetailQuery) async throws -> ContentPage<Character>
}

public struct FetchCharacterDetailQuery {
    let characterID: Int

    public init(characterID: Int) {
        self.characterID = characterID
    }
}

public typealias FetchCharacterDetailUseCaseError = CharacterDetailServiceError

public enum FetchCharacterDetailUseCaseFactory {
    // TODO: Test this
    public static func create(service: CharacterDetailService) -> FetchCharacterDetailUseCase {
        FetchCharacterDetailServiceUseCase(service: service)
    }
}

class FetchCharacterDetailServiceUseCase: FetchCharacterDetailUseCase {
    private let service: CharacterDetailService

    init(service: CharacterDetailService) {
        self.service = service
    }

    func fetch(query: FetchCharacterDetailQuery) async throws -> ContentPage<Character> {
        try await service.character(with: query.characterID)
    }
}
