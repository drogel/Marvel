//
//  FetchComicsUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 4/2/22.
//

import Foundation

public protocol FetchComicsUseCase {
    func fetch(query: FetchComicsQuery) async throws -> ContentPage<Comic>
}

public struct FetchComicsQuery: Equatable {
    public let characterID: Int
    public let offset: Int

    public init(characterID: Int, offset: Int) {
        self.characterID = characterID
        self.offset = offset
    }
}

public typealias FetchComicsUseCaseError = ComicsServiceError

public enum FetchComicsUseCaseFactory {
    public static func create(service: ComicsService) -> FetchComicsUseCase {
        FetchComicsServiceUseCase(service: service)
    }
}

class FetchComicsServiceUseCase: FetchComicsUseCase {
    private let service: ComicsService

    init(service: ComicsService) {
        self.service = service
    }

    func fetch(query: FetchComicsQuery) async throws -> ContentPage<Comic> {
        try await service.comics(for: query.characterID, from: query.offset)
    }
}
