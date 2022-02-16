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
    var pager: Pager { get }
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

    lazy var imageURLBuilder: ImageURLBuilder = SecureImageURLBuilder()

    lazy var pager: Pager = OffsetPager()
}

private extension CharacterDetailDependencyContainer {
    var characterDetailService: CharacterDetailService {
        switch dependencies.scheme {
        case .debug:
            return characterDetailDebugService
        case .release:
            return characterDetailReleaseService
        }
    }

    var comicsDetailService: ComicsService {
        switch dependencies.scheme {
        case .debug:
            return comicsDebugService
        case .release:
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
            client: dependencies.networkService,
            networkResultHandler: resultHandler,
            dataResultHandler: characterDataResultHandler
        )
    }

    var comicsDebugService: ComicsService {
        ComicsDebugService(dataLoader: jsonDataLoader, dataResultHandler: comicDataResultHandler)
    }

    var comicsReleaseService: ComicsService {
        ComicsClientService(
            networkService: dependencies.networkService,
            resultHandler: resultHandler,
            dataResultHandler: comicDataResultHandler
        )
    }

    var jsonDataLoader: JsonDecoderDataLoader {
        JsonDecoderDataLoader(parser: parser)
    }

    var parser: JSONParser {
        JSONDecoderParser()
    }

    var resultHandler: NetworkResultHandler {
        ClientResultHandler(parser: parser, errorHandler: DataServicesNetworkErrorHandler())
    }

    var characterDataResultHandler: CharacterDataResultHandler {
        CharacterDataResultHandlerFactory.createWithDataMappers()
    }

    var comicDataResultHandler: ComicDataResultHandler {
        ComicDataResultHandlerFactory.createWithDataMappers()
    }
}
