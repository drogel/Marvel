//
//  CharactersDebugService.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

class CharactersDebugService: CharactersService {
    private let charactersFileName: DebugDataFileName = .charactersFileName
    private let dataLoader: DataLoaderDebugService
    private let dataResultHandler: CharacterDataResultHandler

    init(dataLoader: JsonDataLoader, dataResultHandler: CharacterDataResultHandler) {
        self.dataLoader = JsonDataLoaderDebugService(dataLoader: dataLoader, fileName: charactersFileName)
        self.dataResultHandler = dataResultHandler
    }

    // TODO: In the data source, make sure we are only appending unique items
    func characters(from _: Int) async throws -> ContentPage<Character> {
        let data: DataWrapper<CharacterData> = try dataLoader.loadData()
        return try dataResultHandler.handle(data)
    }
}
