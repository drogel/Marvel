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
    private let dataResultHandler: ComicDataResultHandler

    init(dataLoader: JsonDataLoader, dataResultHandler: ComicDataResultHandler) {
        self.dataLoader = JsonDataLoaderDebugService(dataLoader: dataLoader, fileName: comicsFileName)
        self.dataResultHandler = dataResultHandler
    }

    func comics(for _: Int, from _: Int, completion: @escaping (ComicsServiceResult) -> Void) -> Disposable? {
        dataLoader.loadData { [weak self] result in
            self?.dataResultHandler.completeWithServiceResult(result, completion: completion)
        }
    }

    func comics(for _: Int, from _: Int) async throws -> ContentPage<Comic> {
        let dataWrapper: DataWrapper<ComicData> = try dataLoader.loadData()
        return try dataResultHandler.handle(dataWrapper)
    }
}
