//
//  CharacterDetailDebugService.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
import Domain

class CharacterDetailDebugService: CharacterDetailService {
    private let characterDetailFileName: DebugDataFileName = .characterDetailFileName
    private let dataLoader: DataLoaderDebugService
    private let dataResultHandler: CharacterDataResultHandler

    init(dataLoader: JsonDataLoader, dataResultHandler: CharacterDataResultHandler) {
        self.dataLoader = JsonDataLoaderDebugService(dataLoader: dataLoader, fileName: characterDetailFileName)
        self.dataResultHandler = dataResultHandler
    }

    func character(with _: Int) async throws -> ContentPage<Character> {
        let data: DataWrapper<CharacterData> = try dataLoader.loadData()
        return try dataResultHandler.handle(data)
    }
}
