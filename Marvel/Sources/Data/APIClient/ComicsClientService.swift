//
//  ComicsClientService.swift
//  Marvel
//
//  Created by Diego Rogel on 7/2/22.
//

import Foundation

class ComicsClientService: ComicsService {
    private let charactersPath = MarvelAPIPaths.characters.rawValue
    private let comicsPath = MarvelAPIPaths.comics.rawValue
    private let resultHandler: ResultHandler
    private let networkService: NetworkService

    init(networkService: NetworkService, resultHandler: ResultHandler) {
        self.resultHandler = resultHandler
        self.networkService = networkService
    }

    func comics(
        for characterID: Int,
        from offset: Int,
        completion: @escaping (ComicsServiceResult) -> Void
    ) -> Cancellable? {
        networkService.request(endpoint: components(for: characterID, offset: offset)) { [weak self] result in
            self?.resultHandler.handle(result: result, completion: completion)
        }
    }
}

private extension ComicsClientService {
    func components(for characterID: Int, offset: Int) -> RequestComponents {
        let components = RequestComponents().appendingPathComponents([charactersPath, String(characterID), comicsPath])
        return components.withOffsetQuery(offset)
    }
}
