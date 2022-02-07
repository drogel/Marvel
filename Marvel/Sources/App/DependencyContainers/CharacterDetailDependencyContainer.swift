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
    var fetchComicsUseCase: FetchComicsUseCase { get }
    var imageURLBuilder: ImageURLBuilder { get }
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

    lazy var fetchComicsUseCase: FetchComicsUseCase = {
        FetchComicsServiceUseCase(service: comicsDetailService)
    }()

    lazy var imageURLBuilder: ImageURLBuilder = {
        ImageDataURLBuilder()
    }()
}

private extension CharacterDetailDependencyContainer {
    var characterDetailService: CharacterDetailService {
        switch dependencies.scheme {
        case .debug:
            return CharacterDetailDebugService(dataLoader: jsonDataLoader)
        case .release:
            return CharacterDetailClientService(client: dependencies.networkService, resultHandler: resultHandler)
        }
    }

    var comicsDetailService: ComicsService {
        switch dependencies.scheme {
        case .debug:
            return ComicsDebugService(dataLoader: jsonDataLoader)
        case .release:
            return ComicsClientService(networkService: dependencies.networkService, resultHandler: resultHandler)
        }
    }

    var jsonDataLoader: JsonDecoderDataLoader {
        JsonDecoderDataLoader(parser: parser)
    }

    var parser: JSONParser {
        JSONDecoderParser()
    }

    var errorHandler: NetworkErrorHandler {
        DataServicesNetworkErrorHandler()
    }

    var resultHandler: ResultHandler {
        ClientResultHandler(parser: parser, errorHandler: errorHandler)
    }
}
