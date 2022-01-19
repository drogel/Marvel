//
//  CharactersDebugService.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

enum CharactersDebugServiceError: Error {
    case dataParsingFailed
}

class CharactersDebugService: CharactersService {

    private let dataLoader: JsonDataLoaderProtocol
    private let charactersFileName = DebugDataFileName.charactersFileName.rawValue

    init(dataLoader: JsonDataLoaderProtocol) {
        self.dataLoader = dataLoader
    }

    func characters(from offset: Int, completion: @escaping (Result<DataWrapper, Error>) -> Void) -> Cancellable? {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.retrieveCharacters(completion: completion)
        }
        return nil
    }
}

private extension CharactersDebugService {

    func retrieveCharacters(completion: @escaping (Result<DataWrapper, Error>) -> Void) {
        guard let characters: DataWrapper = dataLoader.load(fromFileNamed: charactersFileName) else {
            completion(.failure(CharactersDebugServiceError.dataParsingFailed))
            return
        }
        completion(.success(characters))
    }
}
