//
//  FetchComicsUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 4/2/22.
//

import Foundation

protocol FetchComicsUseCase {
    func fetch(query: FetchComicsQuery) async throws -> ContentPage<Comic>
}

struct FetchComicsQuery: Equatable {
    let characterID: Int
    let offset: Int
}

typealias FetchComicsUseCaseError = ComicsServiceError

class FetchComicsServiceUseCase: FetchComicsUseCase {
    private let service: ComicsService

    init(service: ComicsService) {
        self.service = service
    }

    func fetch(query: FetchComicsQuery) async throws -> ContentPage<Comic> {
        try await service.comics(for: query.characterID, from: query.offset)
    }
}
