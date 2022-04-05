//
//  CharactersClientService.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation
import Domain

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

    func characters(from offset: Int) async throws -> ContentPage<Character> {
        do {
            return try await requestCharacters(from: offset)
        } catch let networkError as NetworkError {
            throw networkErrorHandler.handle(networkError)
        } catch {
            throw CharactersServiceError.emptyData
        }
    }
}

private extension CharactersClientService {
    func components(for offset: Int) -> RequestComponents {
        RequestComponents(path: charactersPath).withOffsetQuery(offset)
    }

    func requestCharacters(from offset: Int) async throws -> ContentPage<Character> {
        let data = try await networkService.request(endpoint: components(for: offset))
        let dataWrapper: DataWrapper<CharacterData> = try dataHandler.handle(data)
        return try dataResultHandler.handle(dataWrapper)
    }
}
