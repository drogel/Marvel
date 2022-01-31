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
    private let resultHandler: CharactersResultHandler

    init(client: NetworkService, resultHandler: CharactersResultHandler) {
        self.client = client
        self.resultHandler = resultHandler
    }

    func character(with id: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Cancellable? {
        client.request(endpoint: components(for: id)) { [weak self] result in
            self?.resultHandler.handle(result: result, completion: completion)
        }
    }
}

private extension CharacterDetailClientService {
    func components(for id: Int) -> RequestComponents {
        let characterDetailPath = charactersPath + "/" + String(id)
        return RequestComponents(path: characterDetailPath)
    }
}
