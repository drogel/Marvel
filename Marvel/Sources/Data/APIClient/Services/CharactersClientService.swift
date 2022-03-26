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
    private let dataHandler: NetworkDataHandler
    private let dataResultHandler: CharacterDataResultHandler
    private let networkErrorHandler: NetworkErrorHandler

    init(
        networkService: NetworkService,
        dataHandler: NetworkDataHandler,
        networkErrorHandler: NetworkErrorHandler,
        dataResultHandler: CharacterDataResultHandler
    ) {
        self.networkService = networkService
        self.networkErrorHandler = networkErrorHandler
        self.dataHandler = dataHandler
        self.dataResultHandler = dataResultHandler
    }

    func characters(from offset: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Disposable? {
        Task { @MainActor in await characters(from: offset, completion: completion) }
        return nil
    }

    func characters(from offset: Int, completion: @escaping (CharactersServiceResult) -> Void) async {
        do {
            let contentPage = try await characters(from: offset)
            completion(.success(contentPage))
        } catch let error as NetworkError {
            completion(.failure(networkErrorHandler.handle(error)))
        } catch {
            completion(.failure(.emptyData))
        }
    }

    func characters(from offset: Int) async throws -> ContentPage<Character> {
        let data = try await networkService.request(endpoint: components(for: offset))
        let dataWrapper: DataWrapper<CharacterData> = try dataHandler.handle(data)
        return try dataResultHandler.handle(dataWrapper)
    }
}

private extension CharactersClientService {
    func components(for offset: Int) -> RequestComponents {
        RequestComponents(path: charactersPath).withOffsetQuery(offset)
    }
}
