//
//  CharacterDetailClientService.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

class CharacterDetailClientService: CharacterDetailService {
    private let charactersPath = MarvelAPIPaths.characters.rawValue
    private let networkService: NetworkService
    private let networkResultHandler: NetworkResultHandler
    private let dataResultHandler: CharacterDataResultHandler

    init(
        networkService: NetworkService,
        networkResultHandler: NetworkResultHandler,
        dataResultHandler: CharacterDataResultHandler
    ) {
        self.networkService = networkService
        self.networkResultHandler = networkResultHandler
        self.dataResultHandler = dataResultHandler
    }

    func character(with identifier: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Disposable? {
        Task { @MainActor in await character(with: identifier, completion: completion) }
        return nil
    }

    func character(with identifier: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) async {
        do {
            let data = try await networkService.request(endpoint: components(for: identifier))
            handle(.success(data), completion: completion)
        } catch let error as NetworkError {
            handle(.failure(error), completion: completion)
        } catch {
            handle(.failure(.requestError(error)), completion: completion)
        }
    }
}

private extension CharacterDetailClientService {
    func components(for identifier: Int) -> RequestComponents {
        let characterID = String(identifier)
        return RequestComponents().appendingPathComponents([charactersPath, characterID])
    }

    func handle(_ result: Result<Data?, NetworkError>, completion: @escaping (CharacterDetailServiceResult) -> Void) {
        networkResultHandler.handle(result: result) { [weak self] handlerResult in
            self?.dataResultHandler.completeWithServiceResult(handlerResult, completion: completion)
        }
    }
}
