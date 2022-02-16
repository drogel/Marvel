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

    func characters(from _: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Cancellable? {
        dataLoader.loadData { [weak self] result in
            self?.dataResultHandler.completeWithServiceResult(result, completion: completion)
        }
    }
}
