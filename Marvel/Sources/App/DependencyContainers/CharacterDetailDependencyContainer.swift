//
//  CharacterDetailDependencyContainer.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

protocol CharacterDetailContainer {
    var characterID: Int { get }
    var fetchCharacterDetailUseCase: FetchCharacterDetailUseCase { get }
}

class CharacterDetailDependencyContainer: CharacterDetailContainer {

    let characterID: Int

    private let dependencies: CharactersDependencies

    init(dependencies: CharactersDependencies, characterID: Int) {
        self.dependencies = dependencies
        self.characterID = characterID
    }

    lazy var fetchCharacterDetailUseCase: FetchCharacterDetailUseCase = {
        FetchCharacterDetailServiceUseCase(service: characterDetailService)
    }()
}

private extension CharacterDetailDependencyContainer {

    var characterDetailService: CharacterDetailService {
        switch dependencies.scheme {
        case .debug:
            return CharacterDetailDebugService(dataLoader: JsonDecoderDataLoader(parser: parser))
        case .release:
            return CharacterDetailClientService(client: dependencies.networkService, resultHandler: resultHandler)
        }
    }

    var parser: JSONParser {
        JSONDecoderParser()
    }

    var errorHandler: NetworkErrorHandler {
        DataServicesNetworkErrorHandler()
    }

    var resultHandler: CharactersResultHandler {
        CharactersClientServiceResultHandler(parser: parser, errorHandler: errorHandler)
    }
}
