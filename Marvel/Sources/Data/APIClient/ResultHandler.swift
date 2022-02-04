//
//  CharactersResultHandler.swift
//  Marvel
//
//  Created by Diego Rogel on 30/1/22.
//

import Foundation

typealias DataServiceResult<T: DataObject> = Result<DataWrapper<T>, DataServiceError>

protocol ResultHandler {
    func handle<T: DataObject>(
        result: Result<Data?, NetworkError>,
        completion: @escaping (DataServiceResult<T>) -> Void
    )
}

class ClientResultHandler: ResultHandler {
    private let parser: JSONParser
    private let errorHandler: NetworkErrorHandler

    init(parser: JSONParser, errorHandler: NetworkErrorHandler) {
        self.parser = parser
        self.errorHandler = errorHandler
    }

    func handle<T: DataObject>(
        result: Result<Data?, NetworkError>,
        completion: @escaping (DataServiceResult<T>) -> Void
    ) {
        switch result {
        case let .success(data):
            handleSuccess(with: data, completion: completion)
        case let .failure(error):
            handleFailure(with: error, completion: completion)
        }
    }
}

private extension ClientResultHandler {
    func handleSuccess<T: DataObject>(with data: Data?, completion: @escaping (DataServiceResult<T>) -> Void) {
        guard let data = data, let dataWrapper: DataWrapper<T> = parser.parse(data: data) else {
            completion(.failure(.emptyData))
            return
        }
        completion(.success(dataWrapper))
    }

    func handleFailure<T: DataObject>(with error: NetworkError, completion: @escaping (DataServiceResult<T>) -> Void) {
        let dataServiceError = errorHandler.handle(error)
        completion(.failure(dataServiceError))
    }
}
