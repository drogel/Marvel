//
//  CharacterDetailDebugService.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

class CharacterDetailDebugService: CharacterDetailService {

    private let dataLoader: JsonDataLoader
    private let characterDetailFileName = DebugDataFileName.characterDetailFileName.rawValue

    init(dataLoader: JsonDataLoader) {
        self.dataLoader = dataLoader
    }

    func character(with id: Int, completion: @escaping (CharacterDetailServiceResult) -> Void) -> Cancellable? {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.retrieveCharacter(completion: completion)
        }
        return nil
    }
}

private extension CharacterDetailDebugService {

    func retrieveCharacter(completion: @escaping (CharacterDetailServiceResult) -> Void) {
        guard let character: DataWrapper = dataLoader.load(fromFileNamed: characterDetailFileName) else {
            completion(.failure(.emptyData))
            return
        }
        completion(.success(character))
    }
}
