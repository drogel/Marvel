//
//  CharacterDetailClientService.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

class CharacterDetailClientService: CharacterDetailService {

    private let charactersPath = MarvelAPIPaths.characters.rawValue
    private let client: NetworkService
    private let parser: JSONParser
    private let errorHandler: NetworkErrorHandler

    init(client: NetworkService, parser: JSONParser, errorHandler: NetworkErrorHandler) {
        self.client = client
        self.parser = parser
        self.errorHandler = errorHandler
    }

    func character(with id: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Cancellable? {
        client.request(endpoint: components(for: id)) { [weak self] result in
            self?.handle(result: result, completion: completion)
        }
    }
}

private extension CharacterDetailClientService {

    func components(for id: Int) -> RequestComponents {
        let characterDetailPath = charactersPath + "/" + String(id)
        return RequestComponents(path: characterDetailPath)
    }

    func handle(result: Result<Data?, NetworkError>, completion: @escaping (CharacterDetailServiceResult) -> Void) {
        switch result {
        case .success(let data):
            handleSuccess(with: data, completion: completion)
        case .failure(let error):
            handleFailure(with: error, completion: completion)
        }
    }

    func handleSuccess(with data: Data?, completion: @escaping (CharacterDetailServiceResult) -> Void) {
        guard let data = data, let dataWrapper: DataWrapper = parser.parse(data: data) else {
            completion(.failure(.emptyData))
            return
        }
        completion(.success(dataWrapper))
    }

    func handleFailure(with error: NetworkError, completion: @escaping (CharacterDetailServiceResult) -> Void) {
        let dataServiceError = errorHandler.handle(error)
        completion(.failure(dataServiceError))
    }
}
