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
    private let dataHandler: NetworkDataHandler
    private let networkResultHandler: NetworkResultHandler
    private let dataResultHandler: CharacterDataResultHandler
    private let networkErrorHandler: NetworkErrorHandler

    init(
        networkService: NetworkService,
        dataHandler: NetworkDataHandler,
        networkResultHandler: NetworkResultHandler,
        networkErrorHandler: NetworkErrorHandler,
        dataResultHandler: CharacterDataResultHandler
    ) {
        self.networkService = networkService
        self.networkResultHandler = networkResultHandler
        self.dataResultHandler = dataResultHandler
        self.dataHandler = dataHandler
        self.networkErrorHandler = networkErrorHandler
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

    func character(with identifier: Int) async throws -> ContentPage<Character> {
        do {
            return try await requestCharacter(from: identifier)
        } catch let networkError as NetworkError {
            throw networkErrorHandler.handle(networkError)
        } catch {
            throw CharacterDetailServiceError.emptyData
        }
    }
}

private extension CharacterDetailClientService {
    func components(for identifier: Int) -> RequestComponents {
        let characterID = String(identifier)
        return RequestComponents().appendingPathComponents([charactersPath, characterID])
    }

    func requestCharacter(from identifier: Int) async throws -> ContentPage<Character> {
        let data = try await networkService.request(endpoint: components(for: identifier))
        let dataWrapper: DataWrapper<CharacterData> = try dataHandler.handle(data)
        return try dataResultHandler.handle(dataWrapper)
    }

    func handle(_ result: Result<Data?, NetworkError>, completion: @escaping (CharacterDetailServiceResult) -> Void) {
        networkResultHandler.handle(result: result) { [weak self] handlerResult in
            self?.dataResultHandler.completeWithServiceResult(handlerResult, completion: completion)
        }
    }
}
