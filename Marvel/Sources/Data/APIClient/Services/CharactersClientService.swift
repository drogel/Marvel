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
    private let resultHandler: NetworkResultHandler
    private let dataResultHandler: CharacterDataResultHandler

    init(
        client: NetworkService,
        resultHandler: NetworkResultHandler,
        dataResultHandler: CharacterDataResultHandler
    ) {
        self.client = client
        self.resultHandler = resultHandler
        self.dataResultHandler = dataResultHandler
    }

    func characters(from offset: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Disposable? {
        client.request(endpoint: components(for: offset)) { [weak self] result in
            self?.resultHandler.handle(result: result) { handlerResult in
                self?.dataResultHandler.completeWithServiceResult(handlerResult, completion: completion)
            }
        }
    }
}

private extension CharactersClientService {
    func components(for offset: Int) -> RequestComponents {
        RequestComponents(path: charactersPath).withOffsetQuery(offset)
    }
}
