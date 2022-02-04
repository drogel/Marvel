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
    private let resultHandler: ResultHandler

    init(client: NetworkService, resultHandler: ResultHandler) {
        self.client = client
        self.resultHandler = resultHandler
    }

    func characters(from offset: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Cancellable? {
        client.request(endpoint: components(for: offset)) { [weak self] result in
            self?.resultHandler.handle(result: result, completion: completion)
        }
    }
}

private extension CharactersClientService {
    func components(for offset: Int) -> RequestComponents {
        RequestComponents(path: charactersPath, queryParameters: ["offset": String(offset)])
    }
}
