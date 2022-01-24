//
//  CharactersClientService.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

class CharactersClientService: CharactersService {

    private let charactersPath = MarvelAPIPaths.characters.rawValue
    private let client: NetworkService
    private let parser: JSONParser

    init(client: NetworkService, parser: JSONParser) {
        self.client = client
        self.parser = parser
    }

    func characters(from offset: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Cancellable? {
        let components = components(for: offset)
        return client.request(endpoint: components) { [weak self] result in
            self?.handle(result: result, completion: completion)
        }
    }
}

private extension CharactersClientService {

    func components(for offset: Int) -> RequestComponents {
        RequestComponents(path: charactersPath, queryParameters: ["offset": String(offset)])
    }

    func handle(result: Result<Data?, NetworkError>, completion: @escaping (CharactersServiceResult) -> Void) {
        switch result {
        case .success(let data):
            handleSuccess(with: data, completion: completion)
        case .failure(let error):
            handleFailure(with: error, completion: completion)
        }
    }

    func handleSuccess(with data: Data?, completion: @escaping (CharactersServiceResult) -> Void) {
        guard let data = data, let dataWrapper: DataWrapper = parser.parse(data: data) else {
            completion(.failure(.emptyData))
            return
        }
        completion(.success(dataWrapper))
    }

    func handleFailure(with error: NetworkError, completion: @escaping (CharactersServiceResult) -> Void) {
        switch error {
        case .notConnected:
            fail(withError: .noConnection, completion: completion)
        case .unauthorized:
            fail(withError: .unauthorized, completion: completion)
        default:
            fail(withError: .emptyData, completion: completion)
        }
    }

    func fail(withError error: CharactersServiceError, completion: @escaping (CharactersServiceResult) -> Void) {
        completion(.failure(error))
    }
}
