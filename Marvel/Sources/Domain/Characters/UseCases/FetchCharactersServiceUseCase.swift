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

enum FetchCharactersUseCaseError: Error {
    case emptyData
    case unauthorized
    case noConnection
}

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
        case .success(let dataWrapper):
            completion(buildResult(from: dataWrapper))
        case .failure(let error):
            handle(error, completion: completion)
        }
    }

    func buildResult(from dataWrapper: DataWrapper) -> FetchCharactersResult {
        guard let pageInfo = dataWrapper.data else { return .failure(.emptyData) }
        return .success(pageInfo)
    }

    func handle(_ error: CharactersServiceError, completion: @escaping (FetchCharactersResult) -> Void) {
        switch error {
        case .noConnection:
            fail(withError: .noConnection, completion: completion)
        case .emptyData:
            fail(withError: .emptyData, completion: completion)
        case .unauthorized:
            fail(withError: .unauthorized, completion: completion)
        }
    }

    func fail(withError error: FetchCharactersUseCaseError, completion: @escaping (FetchCharactersResult) -> Void) {
        completion(.failure(error))
    }
}
