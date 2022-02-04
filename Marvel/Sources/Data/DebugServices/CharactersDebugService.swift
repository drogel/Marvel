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

    init(dataLoader: JsonDataLoader) {
        self.dataLoader = JsonDataLoaderDebugService(dataLoader: dataLoader, fileName: charactersFileName)
    }

    func characters(from _: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Cancellable? {
        dataLoader.loadData(completion: completion)
    }
}
