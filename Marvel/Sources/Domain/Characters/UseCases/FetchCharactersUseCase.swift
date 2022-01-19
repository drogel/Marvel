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

enum FetchCharactersUseCaseError: Error {
    case emptyData
}

class FetchCharactersUseCase: FetchCharactersUseCaseProtocol {

    private let service: CharactersService

    init(service: CharactersService) {
        self.service = service
    }

    func fetch(query: FetchCharactersQuery, completion: @escaping (Result<PageInfo, Error>) -> Void) -> Cancellable? {
        service.characters(from: query.offset) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let dataWrapper):
                completion(self.buildResult(from: dataWrapper))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension FetchCharactersUseCase {

    func buildResult(from dataWrapper: DataWrapper) -> Result<PageInfo, Error> {
        guard let pageInfo = dataWrapper.data else { return .failure(FetchCharactersUseCaseError.emptyData) }
        return .success(pageInfo)
    }
}
