//
//  CharacterDetailClientService.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

class CharacterDetailClientService: CharacterDetailService {

    // TODO: Find a way to extract this path for Characters and CharacterDetail
    private let charactersPath = "characters"
    private let client: NetworkService
    private let parser: JSONParser

    init(client: NetworkService, parser: JSONParser) {
        self.client = client
        self.parser = parser
    }

    func character(with id: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Cancellable? {
        let components = components(for: id)
        return client.request(endpoint: components) { [weak self] result in
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
            completion(.failure(.noSuchCharacter))
            return
        }
        completion(.success(dataWrapper))
    }

    func handleFailure(with error: NetworkError, completion: @escaping (CharacterDetailServiceResult) -> Void) {
        completion(.failure(.noSuchCharacter))
    }
}
