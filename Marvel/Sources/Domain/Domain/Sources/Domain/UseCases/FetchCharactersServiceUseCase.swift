//
//  FetchCharactersUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

public protocol FetchCharactersUseCase {
    func fetch(query: FetchCharactersQuery) async throws -> ContentPage<Character>
}

public struct FetchCharactersQuery {
    public let offset: Int

    public init(offset: Int) {
        self.offset = offset
    }
}

public typealias FetchCharactersUseCaseError = CharactersServiceError

public enum FetchCharactersUseCaseFactory {
    public static func create(service: CharactersService) -> FetchCharactersUseCase {
        FetchCharactersServiceUseCase(service: service)
    }
}

class FetchCharactersServiceUseCase: FetchCharactersUseCase {
    private let service: CharactersService

    init(service: CharactersService) {
        self.service = service
    }

    func fetch(query: FetchCharactersQuery) async throws -> ContentPage<Character> {
        try await service.characters(from: query.offset)
    }
}
