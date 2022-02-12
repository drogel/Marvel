//
//  FetchComicsUseCase.swift
//  Marvel
//
//  Created by Diego Rogel on 4/2/22.
//

import Foundation

protocol FetchComicsUseCase {
    func fetch(
        query: FetchComicsQuery,
        completion: @escaping (FetchComicsResult) -> Void
    ) -> Cancellable?
}

struct FetchComicsQuery: Equatable {
    let characterID: Int
    let offset: Int
}

typealias FetchComicsUseCaseError = ComicsServiceError

typealias FetchComicsResult = Result<PageInfo<ComicData>, FetchComicsUseCaseError>

class FetchComicsServiceUseCase: FetchComicsUseCase {
    private let service: ComicsService

    init(service: ComicsService) {
        self.service = service
    }

    func fetch(
        query: FetchComicsQuery,
        completion: @escaping (FetchComicsResult) -> Void
    ) -> Cancellable? {
        service.comics(for: query.characterID, from: query.offset) { [weak self] result in
            guard let self = self else { return }
            self.handle(result, completion: completion)
        }
    }
}

private extension FetchComicsServiceUseCase {
    func handle(_ result: ComicsServiceResult, completion: @escaping (FetchComicsResult) -> Void) {
        switch result {
        case let .success(dataWrapper):
            completion(buildResult(from: dataWrapper))
        case let .failure(error):
            completion(.failure(error))
        }
    }

    func buildResult(from dataWrapper: DataWrapper<ComicData>) -> FetchComicsResult {
        guard let pageInfo = dataWrapper.data else { return .failure(.emptyData) }
        return .success(pageInfo)
    }
}
