//
//  CharactersClientService.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

class CharactersClientService: CharactersService {
    private let charactersPath = MarvelAPIPaths.characters.rawValue
    private let networkService: NetworkService
    private let resultHandler: NetworkResultHandler
    private let dataResultHandler: CharacterDataResultHandler

    init(
        networkService: NetworkService,
        resultHandler: NetworkResultHandler,
        dataResultHandler: CharacterDataResultHandler
    ) {
        self.networkService = networkService
        self.resultHandler = resultHandler
        self.dataResultHandler = dataResultHandler
    }

    func characters(from offset: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Disposable? {
        Task { @MainActor in await characters(from: offset, completion: completion) }
        return nil
    }

    func characters(from offset: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) async {
        do {
            let data = try await networkService.request(endpoint: components(for: offset))
            handle(.success(data), completion: completion)
        } catch let error as NetworkError {
            handle(.failure(error), completion: completion)
        } catch {
            handle(.failure(.requestError(error)), completion: completion)
        }
    }
}

private extension CharactersClientService {
    func components(for offset: Int) -> RequestComponents {
        RequestComponents(path: charactersPath).withOffsetQuery(offset)
    }

    func handle(_ result: Result<Data?, NetworkError>, completion: @escaping (CharactersServiceResult) -> Void) {
        resultHandler.handle(result: result) { [weak self] handlerResult in
            self?.dataResultHandler.completeWithServiceResult(handlerResult, completion: completion)
        }
    }
}
