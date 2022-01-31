//
//  CharactersDebugService.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

class CharactersDebugService: CharactersService {
    private let dataLoader: JsonDataLoader
    private let charactersFileName = DebugDataFileName.charactersFileName.rawValue

    init(dataLoader: JsonDataLoader) {
        self.dataLoader = dataLoader
    }

    func characters(from _: Int, completion: @escaping (CharactersServiceResult) -> Void) -> Cancellable? {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.retrieveCharacters(completion: completion)
        }
        return nil
    }
}

private extension CharactersDebugService {
    func retrieveCharacters(completion: @escaping (CharactersServiceResult) -> Void) {
        guard let characters: DataWrapper = dataLoader.load(fromFileNamed: charactersFileName) else {
            completion(.failure(.emptyData))
            return
        }
        completion(.success(characters))
    }
}
