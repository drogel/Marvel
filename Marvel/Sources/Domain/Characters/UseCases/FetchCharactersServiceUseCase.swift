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

typealias FetchCharactersResult = Result<PageInfo, FetchCharactersUseCaseError>

class FetchCharactersServiceUseCase: FetchCharactersUseCase {
    private let service: CharactersService

    init(service: CharactersService) {
        self.service = service
    }

    func fetch(query: FetchCharactersQuery, completion: @escaping (FetchCharactersResult) -> Void) -> Cancellable? {
        service.characters(from: query.offset) { [weak self] result in
            guard let self = self else { return }
            self.handle(result, completion: completion)
        }
    }
}

private extension FetchCharactersServiceUseCase {
    func handle(_ result: CharactersServiceResult, completion: @escaping (FetchCharactersResult) -> Void) {
        switch result {
        case let .success(dataWrapper):
            completion(buildResult(from: dataWrapper))
        case let .failure(error):
            completion(.failure(error))
        }
    }

    func buildResult(from dataWrapper: DataWrapper) -> FetchCharactersResult {
        guard let pageInfo = dataWrapper.data else { return .failure(.emptyData) }
        return .success(pageInfo)
    }
}
