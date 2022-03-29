//
//  FetchComicsUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 4/2/22.
//

import Foundation

protocol FetchComicsUseCase {
    func fetch(
        query: FetchComicsQuery,
        completion: @escaping (FetchComicsResult) -> Void
    ) -> Disposable?

    func fetch(query: FetchComicsQuery) async throws -> ContentPage<Comic>
}

struct FetchComicsQuery: Equatable {
    let characterID: Int
    let offset: Int
}

typealias FetchComicsUseCaseError = ComicsServiceError

typealias FetchComicsResult = Result<ContentPage<Comic>, FetchComicsUseCaseError>

class FetchComicsServiceUseCase: FetchComicsUseCase {
    private let service: ComicsService

    init(service: ComicsService) {
        self.service = service
    }

    func fetch(
        query: FetchComicsQuery,
        completion: @escaping (FetchComicsResult) -> Void
    ) -> Disposable? {
        Task { await fetch(query: query, completion: completion) }
        return nil
    }

    func fetch(
        query: FetchComicsQuery,
        completion: @escaping (FetchComicsResult) -> Void
    ) async {
        do {
            let contentPage = try await fetch(query: query)
            completion(.success(contentPage))
        } catch let error as ComicsServiceError {
            completion(.failure(error))
        } catch {
            completion(.failure(.emptyData))
        }
    }

    func fetch(query: FetchComicsQuery) async throws -> ContentPage<Comic> {
        try await service.comics(for: query.characterID, from: query.offset)
    }
}
