//
//  ComicsDebugService.swift
//  Marvel
//
//  Created by Diego Rogel on 4/2/22.
//

import Foundation

class ComicsDebugService: ComicsService {
    private let comicsFileName: DebugDataFileName = .comicsFileName
    private let dataLoader: DataLoaderDebugService

    init(dataLoader: JsonDataLoader) {
        self.dataLoader = JsonDataLoaderDebugService(dataLoader: dataLoader, fileName: comicsFileName)
    }

    func comics(for _: Int, from _: Int, completion: @escaping (ComicsServiceResult) -> Void) -> Cancellable? {
        dataLoader.loadData(completion: completion)
    }
}
