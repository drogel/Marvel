//
//  FetchCharacterDetailUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

protocol FetchCharacterDetailUseCase {
    func fetch(query: FetchCharacterDetailQuery, completion: @escaping (FetchCharacterDetailResult) -> Void) -> Cancellable?
}

struct FetchCharacterDetailQuery {
    let characterID: Int
}

enum FetchCharacterDetailUseCaseError: Error {
    case noSuchCharacter
    case unauthorized
    case noConnection
}

typealias FetchCharacterDetailResult = Result<PageInfo, FetchCharacterDetailUseCaseError>

class FetchCharacterDetailServiceUseCase: FetchCharacterDetailUseCase {

    private let service: CharacterDetailService

    init(service: CharacterDetailService) {
        self.service = service
    }

    func fetch(query: FetchCharacterDetailQuery, completion: @escaping (FetchCharacterDetailResult) -> Void) -> Cancellable? {
        service.character(with: query.characterID) { [weak self] result in
            guard let self = self else { return }
            self.handle(result, completion: completion)
        }
    }
}

private extension FetchCharacterDetailServiceUseCase {

    func handle(_ result: CharacterDetailServiceResult, completion: @escaping (FetchCharacterDetailResult) -> Void) {
        switch result {
        case .success(let dataWrapper):
            completion(buildResult(from: dataWrapper))
        case .failure(let error):
            handle(error, completion: completion)
        }
    }

    func buildResult(from dataWrapper: DataWrapper) -> FetchCharacterDetailResult {
        guard let pageInfo = dataWrapper.data else { return .failure(FetchCharacterDetailUseCaseError.noSuchCharacter) }
        return .success(pageInfo)
    }

    func handle(_ error: CharacterDetailServiceError, completion: @escaping (FetchCharacterDetailResult) -> Void) {
        switch error {
        case .noConnection:
            fail(withError: .noConnection, completion: completion)
        case .noSuchCharacter:
            fail(withError: .noSuchCharacter, completion: completion)
        case .unauthorized:
            fail(withError: .unauthorized, completion: completion)
        }
    }

    func fail(withError error: FetchCharacterDetailUseCaseError, completion: @escaping (FetchCharacterDetailResult) -> Void) {
        completion(.failure(error))
    }
}
