//
//  ComicsClientService.swift
//  Marvel
//
//  Created by Diego Rogel on 7/2/22.
//

import Domain
import Foundation

class ComicsClientService: ComicsService {
    private let charactersPath = MarvelAPIPaths.characters.rawValue
    private let comicsPath = MarvelAPIPaths.comics.rawValue
    private let networkService: NetworkService
    private let dataHandler: NetworkDataHandler
    private let dataResultHandler: ComicDataResultHandler

    init(
        networkService: NetworkService,
        dataHandler: NetworkDataHandler,
        dataResultHandler: ComicDataResultHandler
    ) {
        self.networkService = networkService
        self.dataResultHandler = dataResultHandler
        self.dataHandler = dataHandler
    }

    func comics(for characterID: Int, from offset: Int) async throws -> ContentPage<Comic> {
        let data = try await networkService.request(endpoint: components(for: characterID, offset: offset))
        let dataWrapper: DataWrapper<ComicData> = try dataHandler.handle(data)
        return try dataResultHandler.handle(dataWrapper)
    }
}

private extension ComicsClientService {
    func components(for characterID: Int, offset: Int) -> RequestComponents {
        let components = RequestComponents().appendingPathComponents([charactersPath, String(characterID), comicsPath])
        return components.withOffsetQuery(offset)
    }
}
