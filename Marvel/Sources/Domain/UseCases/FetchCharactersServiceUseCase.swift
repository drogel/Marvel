//
//  FetchCharactersUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

protocol FetchCharactersUseCase {
    func fetch(query: FetchCharactersQuery, completion: @escaping (FetchCharactersResult) -> Void) -> Disposable?
}

struct FetchCharactersQuery {
    let offset: Int
}

typealias FetchCharactersUseCaseError = CharactersServiceError

typealias FetchCharactersResult = Result<ContentPage<Character>, FetchCharactersUseCaseError>

class FetchCharactersServiceUseCase: FetchCharactersUseCase {
    private let service: CharactersService

    init(service: CharactersService) {
        self.service = service
    }

    func fetch(query: FetchCharactersQuery, completion: @escaping (FetchCharactersResult) -> Void) -> Disposable? {
        Task { await fetch(query: query, completion: completion) }
        return nil
    }

    func fetch(query: FetchCharactersQuery, completion: @escaping (FetchCharactersResult) -> Void) async {
        do {
            let charactersPage = try await service.characters(from: query.offset)
            completion(.success(charactersPage))
        } catch let error as CharactersServiceError {
            completion(.failure(error))
        } catch {
            completion(.failure(.emptyData))
        }
    }
}
