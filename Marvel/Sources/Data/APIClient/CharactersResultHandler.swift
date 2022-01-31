//
//  CharactersResultHandler.swift
//  Marvel
//
//  Created by Diego Rogel on 30/1/22.
//

import Foundation

protocol CharactersResultHandler {
    func handle(result: Result<Data?, NetworkError>, completion: @escaping (CharactersServiceResult) -> Void)
}

class CharactersClientServiceResultHandler: CharactersResultHandler {

    private let parser: JSONParser
    private let errorHandler: NetworkErrorHandler

    init(parser: JSONParser, errorHandler: NetworkErrorHandler) {
        self.parser = parser
        self.errorHandler = errorHandler
    }

    func handle(result: Result<Data?, NetworkError>, completion: @escaping (CharactersServiceResult) -> Void) {
        switch result {
        case .success(let data):
            handleSuccess(with: data, completion: completion)
        case .failure(let error):
            handleFailure(with: error, completion: completion)
        }
    }
}

private extension CharactersClientServiceResultHandler {

    func handleSuccess(with data: Data?, completion: @escaping (CharactersServiceResult) -> Void) {
        guard let data = data, let dataWrapper: DataWrapper = parser.parse(data: data) else {
            completion(.failure(.emptyData))
            return
        }
        completion(.success(dataWrapper))
    }

    func handleFailure(with error: NetworkError, completion: @escaping (CharactersServiceResult) -> Void) {
        let dataServiceError = errorHandler.handle(error)
        completion(.failure(dataServiceError))
    }
}
