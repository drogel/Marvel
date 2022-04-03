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

    func fetch(
        query: FetchCharacterDetailQuery,
        completion: @escaping (FetchCharacterDetailResult) -> Void
    ) -> Disposable? {
        Task { await fetch(query: query, completion: completion) }
        return nil
    }

    func fetch(
        query: FetchCharacterDetailQuery,
        completion: @escaping (FetchCharacterDetailResult) -> Void
    ) async -> Disposable? {
        do {
            let characterPage = try await fetch(query: query)
            completion(.success(characterPage))
        } catch let error as CharacterDetailServiceError {
            completion(.failure(error))
        } catch {
            completion(.failure(.emptyData))
        }
        return nil
    }

    func fetch(query: FetchCharacterDetailQuery) async throws -> ContentPage<Character> {
        try await service.character(with: query.characterID)
    }
}
