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

    init(dataLoader: JsonDataLoader) {
        self.dataLoader = JsonDataLoaderDebugService(dataLoader: dataLoader, fileName: characterDetailFileName)
    }

    func character(with _: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Cancellable? {
        dataLoader.loadData(completion: completion)
    }
}
