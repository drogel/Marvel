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
    ) -> Disposable?
}

struct FetchComicsQuery: Equatable {
    let characterID: Int
    let offset: Int
}

typealias FetchComicsUseCaseError = ComicsServiceError

typealias FetchComicsResult = Result<ContentPage<Comic>, FetchComicsUseCaseError>

class FetchComicsServiceUseCase: FetchComicsUseCase {
    private let service: ComicsService

    init(service: ComicsService) {
        self.service = service
    }

    func fetch(
        query: FetchComicsQuery,
        completion: @escaping (FetchComicsResult) -> Void
    ) -> Disposable? {
        service.comics(for: query.characterID, from: query.offset, completion: completion)
    }
}
