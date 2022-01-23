//
//  FetchCharacterDetailUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

protocol FetchCharacterDetailUseCase {
    func fetch(query: FetchCharacterDetailQuery, completion: @escaping (Result<PageInfo, Error>) -> Void) -> Cancellable?
}

struct FetchCharacterDetailQuery {
    let characterID: Int
}

enum FetchCharacterDetailUseCaseError: Error {
    case noSuchCharacter
}

class FetchCharacterDetailServiceUseCase: FetchCharacterDetailUseCase {

    private let service: CharacterDetailService

    init(service: CharacterDetailService) {
        self.service = service
    }

    func fetch(query: FetchCharacterDetailQuery, completion: @escaping (Result<PageInfo, Error>) -> Void) -> Cancellable? {
        service.character(with: query.characterID) { [weak self] result in
            guard let self = self else { return }
            self.handle(result, completion: completion)
        }
    }
}

private extension FetchCharacterDetailServiceUseCase {

    func handle(_ result: CharacterDetailServiceResult, completion: @escaping (Result<PageInfo, Error>) -> Void) {
        switch result {
        case .success(let dataWrapper):
            completion(buildResult(from: dataWrapper))
        case .failure(let error):
            completion(.failure(error))
        }
    }

    func buildResult(from dataWrapper: DataWrapper) -> Result<PageInfo, Error> {
        guard let pageInfo = dataWrapper.data else { return .failure(FetchCharacterDetailUseCaseError.noSuchCharacter) }
        return .success(pageInfo)
    }
}
