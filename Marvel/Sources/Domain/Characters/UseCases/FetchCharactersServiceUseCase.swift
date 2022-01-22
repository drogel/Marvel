//
//  FetchCharactersUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

protocol FetchCharactersUseCase {
    func fetch(query: FetchCharactersQuery, completion: @escaping (Result<PageInfo, Error>) -> Void) -> Cancellable?
}

struct FetchCharactersQuery {
    let offset: Int
}

enum FetchCharactersUseCaseError: Error {
    case emptyData
}

class FetchCharactersServiceUseCase: FetchCharactersUseCase {

    private let service: CharactersService

    init(service: CharactersService) {
        self.service = service
    }

    func fetch(query: FetchCharactersQuery, completion: @escaping (Result<PageInfo, Error>) -> Void) -> Cancellable? {
        service.characters(from: query.offset) { [weak self] result in
            guard let self = self else { return }
            self.handle(result, completion: completion)
        }
    }
}

private extension FetchCharactersServiceUseCase {

    func handle(_ result: CharactersServiceResult, completion: @escaping (Result<PageInfo, Error>) -> Void) {
        switch result {
        case .success(let dataWrapper):
            completion(buildResult(from: dataWrapper))
        case .failure(let error):
            completion(.failure(error))
        }
    }

    func buildResult(from dataWrapper: DataWrapper) -> Result<PageInfo, Error> {
        guard let pageInfo = dataWrapper.data else { return .failure(FetchCharactersUseCaseError.emptyData) }
        return .success(pageInfo)
    }
}
