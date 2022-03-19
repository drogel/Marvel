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
    ) -> Disposable? {
        Task { await comics(for: characterID, from: offset, completion: completion) }
        return nil
    }

    // TODO: Remove this kind of workarounds for tests
    func comics(
        for characterID: Int,
        from offset: Int,
        completion: @escaping (ComicsServiceResult) -> Void
    ) async {
        do {
            let data = try await networkService.request(endpoint: components(for: characterID, offset: offset))
            handle(.success(data), completion: completion)
        } catch let error as NetworkError {
            handle(.failure(error), completion: completion)
        } catch {
            handle(.failure(.requestError(error)), completion: completion)
        }
    }
}

private extension ComicsClientService {
    func components(for characterID: Int, offset: Int) -> RequestComponents {
        let components = RequestComponents().appendingPathComponents([charactersPath, String(characterID), comicsPath])
        return components.withOffsetQuery(offset)
    }

    func handle(_ result: Result<Data?, NetworkError>, completion: @escaping (ComicsServiceResult) -> Void) {
        resultHandler.handle(result: result) { [weak self] handlerResult in
            self?.dataResultHandler.completeWithServiceResult(handlerResult, completion: completion)
        }
    }
}
