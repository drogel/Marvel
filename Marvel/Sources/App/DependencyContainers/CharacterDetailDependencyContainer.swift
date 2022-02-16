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
            characterMapper: characterMapper,
            pageMapper: pageMapper
        )
    }

    var characterDetailReleaseService: CharacterDetailService {
        CharacterDetailClientService(
            client: dependencies.networkService,
            networkResultHandler: resultHandler,
            dataResultHandler: dataResultHandler
        )
    }

    var comicsDebugService: ComicsService {
        ComicsDebugService(dataLoader: jsonDataLoader, comicMapper: comicMapper, pageMapper: pageMapper)
    }

    var comicsReleaseService: ComicsService {
        ComicsClientService(
            networkService: dependencies.networkService,
            resultHandler: resultHandler,
            comicMapper: comicMapper,
            pageMapper: pageMapper
        )
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

    var resultHandler: NetworkResultHandler {
        ClientResultHandler(parser: parser, errorHandler: errorHandler)
    }

    var dataResultHandler: CharacterDataResultHandler {
        CharacterDataServiceResultHandler(characterMapper: characterMapper, pageMapper: pageMapper)
    }

    var pageMapper: PageMapper {
        PageDataMapper()
    }

    var comicMapper: ComicMapper {
        ComicDataMapper(imageMapper: imageMapper)
    }

    var characterMapper: CharacterMapper {
        CharacterDataMapper(imageMapper: imageMapper)
    }

    var imageMapper: ImageMapper {
        ImageDataMapper()
    }
}
