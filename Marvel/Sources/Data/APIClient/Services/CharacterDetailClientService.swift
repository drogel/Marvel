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
    private let networkResultHandler: NetworkResultHandler
    private let dataResultHandler: CharacterDataResultHandler

    init(
        client: NetworkService,
        networkResultHandler: NetworkResultHandler,
        dataResultHandler: CharacterDataResultHandler
    ) {
        self.client = client
        self.networkResultHandler = networkResultHandler
        self.dataResultHandler = dataResultHandler
    }

    func character(with identifier: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Disposable? {
        client.request(endpoint: components(for: identifier)) { [weak self] result in
            self?.networkResultHandler.handle(result: result) { handlerResult in
                self?.dataResultHandler.completeWithServiceResult(handlerResult, completion: completion)
            }
        }
    }
}

private extension CharacterDetailClientService {
    func components(for identifier: Int) -> RequestComponents {
        let characterID = String(identifier)
        return RequestComponents().appendingPathComponents([charactersPath, characterID])
    }
}
