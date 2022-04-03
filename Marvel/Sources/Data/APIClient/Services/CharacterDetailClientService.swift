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
    private let dataResultHandler: CharacterDataResultHandler
    private let networkErrorHandler: NetworkErrorHandler

    init(
        networkService: NetworkService,
        dataHandler: NetworkDataHandler,
        networkErrorHandler: NetworkErrorHandler,
        dataResultHandler: CharacterDataResultHandler
    ) {
        self.networkService = networkService
        self.dataResultHandler = dataResultHandler
        self.dataHandler = dataHandler
        self.networkErrorHandler = networkErrorHandler
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
}
