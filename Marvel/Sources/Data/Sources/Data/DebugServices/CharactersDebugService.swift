//
//  CharactersDebugService.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Domain
import Foundation

public class CharactersDebugService: CharactersService {
    private let charactersFileName: DebugDataFileName = .charactersFileName
    private let dataLoader: DataLoaderDebugService
    private let dataResultHandler: CharacterDataResultHandler
    private var didLoadCharacters = false

    public init(dataLoader: JsonDataLoader, dataResultHandler: CharacterDataResultHandler) {
        self.dataLoader = JsonDataLoaderDebugService(dataLoader: dataLoader, fileName: charactersFileName)
        self.dataResultHandler = dataResultHandler
    }

    public func characters(from _: Int) async throws -> ContentPage<Character> {
        guard !didLoadCharacters else { throw CharactersServiceError.emptyData }
        let data: DataWrapper<CharacterData> = try dataLoader.loadData()
        didLoadCharacters = true
        return try dataResultHandler.handle(data)
    }
}
