//
//  CharactersDependencyContainer.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Domain
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

    lazy var fetchCharactersUseCase = FetchCharactersUseCaseFactory.create(service: charactersService)
    lazy var imageURLBuilder = ImageURLBuilderFactory.create()
    lazy var pager = PagerFactory.create()
}

private extension CharactersDependencyContainer {
    var charactersService: CharactersService {
        switch dependencies.scheme {
        case .debug:
            return charactersDebugService
        case .stage, .release:
            return charactersClientService
        }
    }

    var charactersClientService: CharactersService {
        CharactersClientService(
            networkService: dependencies.networkService,
            dataHandler: ClientDataHandler(parser: parser),
            networkErrorHandler: errorHandler,
            dataResultHandler: dataResultHandler
        )
    }

    var charactersDebugService: CharactersService {
        CharactersDebugService(
            dataLoader: JsonDecoderDataLoader(parser: parser),
            dataResultHandler: dataResultHandler
        )
    }

    var parser: JSONParser {
        JSONDecoderParser()
    }

    var errorHandler: NetworkErrorHandler {
        DataServicesNetworkErrorHandler()
    }

    var dataResultHandler: CharacterDataResultHandler {
        CharacterDataResultHandlerFactory.createWithDataMappers()
    }
}
