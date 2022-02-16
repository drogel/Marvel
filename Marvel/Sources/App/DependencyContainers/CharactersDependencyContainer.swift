//
//  CharactersDependencyContainer.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation

protocol CharactersDependencies {
    var networkService: NetworkService { get }
    var scheme: AppScheme { get }
}

class CharactersDependenciesAdapter: CharactersDependencies {
    let networkService: NetworkService
    let scheme: AppScheme

    init(networkService: NetworkService, scheme: AppScheme) {
        self.networkService = networkService
        self.scheme = scheme
    }
}

protocol CharactersContainer {
    var fetchCharactersUseCase: FetchCharactersUseCase { get }
    var imageURLBuilder: ImageURLBuilder { get }
    var pager: Pager { get }
}

class CharactersDependencyContainer: CharactersContainer {
    private let dependencies: CharactersDependencies

    init(dependencies: CharactersDependencies) {
        self.dependencies = dependencies
    }

    lazy var fetchCharactersUseCase: FetchCharactersUseCase = {
        FetchCharactersServiceUseCase(service: charactersService)
    }()

    lazy var imageURLBuilder: ImageURLBuilder = SecureImageURLBuilder()

    lazy var pager: Pager = OffsetPager()
}

private extension CharactersDependencyContainer {
    var charactersService: CharactersService {
        switch dependencies.scheme {
        case .debug:
            return charactersDebugService
        case .release:
            return charactersClientService
        }
    }

    var charactersClientService: CharactersService {
        CharactersClientService(
            client: dependencies.networkService,
            resultHandler: resultHandler,
            characterMapper: characterMapper,
            pageMapper: pageMapper
        )
    }

    var charactersDebugService: CharactersService {
        CharactersDebugService(
            dataLoader: JsonDecoderDataLoader(parser: parser),
            characterMapper: characterMapper,
            pageMapper: pageMapper
        )
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

    var characterMapper: CharacterMapper {
        CharacterDataMapper(imageMapper: ImageDataMapper())
    }

    var pageMapper: PageMapper {
        PageDataMapper()
    }
}
