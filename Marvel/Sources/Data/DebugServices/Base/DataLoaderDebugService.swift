//
//  DataLoaderDebugService.swift
//  Marvel
//
//  Created by Diego Rogel on 4/2/22.
//

import Foundation

protocol DataLoaderDebugService {
    func loadData<T: DataObject>(completion: @escaping (DataServiceResult<T>) -> Void) -> Disposable?
}

class JsonDataLoaderDebugService: DataLoaderDebugService {
    private let fileName: DebugDataFileName
    private let dataLoader: JsonDataLoader

    init(dataLoader: JsonDataLoader, fileName: DebugDataFileName) {
        self.dataLoader = dataLoader
        self.fileName = fileName
    }

    func loadData<T: DataObject>(
        completion: @escaping (DataServiceResult<T>) -> Void
    ) -> Disposable? {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.retrieveData(completion: completion)
        }
        return nil
    }
}

private extension JsonDataLoaderDebugService {
    func retrieveData<T: DataObject>(completion: @escaping (DataServiceResult<T>) -> Void) {
        guard let data: DataWrapper<T> = dataLoader.load(fromFileNamed: fileName.rawValue) else {
            completion(.failure(.emptyData))
            return
        }
        completion(.success(data))
    }
}
