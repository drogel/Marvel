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
    private let resultHandler: NetworkResultHandler
    private let networkService: NetworkService
    private let dataResultHandler: ComicDataResultHandler

    init(
        networkService: NetworkService,
        resultHandler: NetworkResultHandler,
        dataResultHandler: ComicDataResultHandler
    ) {
        self.resultHandler = resultHandler
        self.networkService = networkService
        self.dataResultHandler = dataResultHandler
    }

    func comics(
        for characterID: Int,
        from offset: Int,
        completion: @escaping (ComicsServiceResult) -> Void
    ) -> Cancellable? {
        networkService.request(endpoint: components(for: characterID, offset: offset)) { [weak self] result in
            self?.resultHandler.handle(result: result) { handlerResult in
                self?.dataResultHandler.completeWithServiceResult(handlerResult, completion: completion)
            }
        }
    }
}

private extension ComicsClientService {
    func components(for characterID: Int, offset: Int) -> RequestComponents {
        let components = RequestComponents().appendingPathComponents([charactersPath, String(characterID), comicsPath])
        return components.withOffsetQuery(offset)
    }
}
