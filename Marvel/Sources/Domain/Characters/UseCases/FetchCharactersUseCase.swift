//
//  FetchCharactersUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

protocol FetchCharactersUseCaseProtocol {
    func fetch(query: FetchCharactersQuery, completion: @escaping (Result<PageInfo, Error>) -> Void) -> Cancellable?
}

struct FetchCharactersQuery {
    let offset: Int
}

class FetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    func fetch(query: FetchCharactersQuery, completion: @escaping (Result<PageInfo, Error>) -> Void) -> Cancellable? {
        // TODO: Implement
        return nil
    }
}
