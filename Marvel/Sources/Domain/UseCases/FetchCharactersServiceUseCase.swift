//
//  FetchCharactersUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

protocol FetchCharactersUseCase {
    func fetch(query: FetchCharactersQuery, completion: @escaping (FetchCharactersResult) -> Void) -> Cancellable?
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

    func fetch(query: FetchCharactersQuery, completion: @escaping (FetchCharactersResult) -> Void) -> Cancellable? {
        service.characters(from: query.offset, completion: completion)
    }
}
