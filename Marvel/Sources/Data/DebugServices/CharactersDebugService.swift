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
    private var didTryLoadingData = false

    init(dataLoader: JsonDataLoader, dataResultHandler: CharacterDataResultHandler) {
        self.dataLoader = JsonDataLoaderDebugService(dataLoader: dataLoader, fileName: charactersFileName)
        self.dataResultHandler = dataResultHandler
    }

    func characters(from _: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Disposable? {
        guard !didTryLoadingData else { return nil }
        didTryLoadingData = true
        return dataLoader.loadData { [weak self] result in
            self?.dataResultHandler.completeWithServiceResult(result, completion: completion)
        }
    }

    func characters(from _: Int) async throws -> ContentPage<Character> {
        let data: DataWrapper<CharacterData> = try dataLoader.loadData()
        return try dataResultHandler.handle(data)
    }
}
