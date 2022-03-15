//
//  CharacterDetailDebugService.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

class CharacterDetailDebugService: CharacterDetailService {
    private let characterDetailFileName: DebugDataFileName = .characterDetailFileName
    private let dataLoader: DataLoaderDebugService
    private let dataResultHandler: CharacterDataResultHandler

    init(dataLoader: JsonDataLoader, dataResultHandler: CharacterDataResultHandler) {
        self.dataLoader = JsonDataLoaderDebugService(dataLoader: dataLoader, fileName: characterDetailFileName)
        self.dataResultHandler = dataResultHandler
    }

    func character(with _: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Disposable? {
        dataLoader.loadData { [weak self] result in
            self?.dataResultHandler.completeWithServiceResult(result, completion: completion)
        }
    }
}
