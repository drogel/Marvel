//
//  CharacterDetailDependencyContainer.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Data
import Domain
import Foundation

protocol CharacterDetailContainer {
    var characterID: Int { get }
    var fetchCharacterDetailUseCase: FetchCharacterDetailUseCase { get }
    var fetchComicsUseCase: FetchComicsUseCase { get }
    var imageURLBuilder: ImageURLBuilder { get }
    var pager: Pager { get }
}

class CharacterDetailDependencyContainer: CharacterDetailContainer {
    let characterID: Int

    private let dependencies: CharactersDependencies

    init(dependencies: CharactersDependencies, characterID: Int) {
        self.dependencies = dependencies
        self.characterID = characterID
    }

    lazy var fetchCharacterDetailUseCase = FetchCharacterDetailUseCaseFactory.create(service: characterDetailService)
    lazy var fetchComicsUseCase = FetchComicsUseCaseFactory.create(service: comicsDetailService)
    lazy var imageURLBuilder: ImageURLBuilder = ImageURLBuilderFactory.create()
    lazy var pager: Pager = PagerFactory.create()
}

private extension CharacterDetailDependencyContainer {
    var characterDetailService: CharacterDetailService {
        switch dependencies.scheme {
        case .debug:
            return characterDetailDebugService
        case .stage, .release:
            return characterDetailReleaseService
        }
    }

    var comicsDetailService: ComicsService {
        switch dependencies.scheme {
        case .debug:
            return comicsDebugService
        case .stage, .release:
            return comicsReleaseService
        }
    }

    var characterDetailDebugService: CharacterDetailService {
        CharacterDetailDebugService(
            dataLoader: jsonDataLoader,
            dataResultHandler: characterDataResultHandler
        )
    }

    var characterDetailReleaseService: CharacterDetailService {
        CharacterDetailClientService(
            networkService: dependencies.networkService,
            dataHandler: dataHandler,
            networkErrorHandler: errorHandler,
            dataResultHandler: characterDataResultHandler
        )
    }

    var comicsDebugService: ComicsService {
        ComicsDebugService(dataLoader: jsonDataLoader, dataResultHandler: comicDataResultHandler)
    }

    var comicsReleaseService: ComicsService {
        ComicsClientService(
            networkService: dependencies.networkService,
            dataHandler: dataHandler,
            dataResultHandler: comicDataResultHandler
        )
    }

    var dataHandler: NetworkDataHandler {
        ClientDataHandler(parser: parser)
    }

    var errorHandler: NetworkErrorHandler {
        DataServicesNetworkErrorHandler()
    }

    var jsonDataLoader: JsonDecoderDataLoader {
        JsonDecoderDataLoader(parser: parser)
    }

    var parser: JSONParser {
        JSONDecoderParser()
    }

    var characterDataResultHandler: CharacterDataResultHandler {
        CharacterDataResultHandlerFactory.createWithDataMappers()
    }

    var comicDataResultHandler: ComicDataResultHandler {
        ComicDataResultHandlerFactory.createWithDataMappers()
    }
}
