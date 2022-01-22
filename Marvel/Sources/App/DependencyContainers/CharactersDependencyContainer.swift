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

class CharactersDependencyContainer {

    private let dependencies: CharactersDependencies

    init(dependencies: CharactersDependencies) {
        self.dependencies = dependencies
    }

    lazy var fetchCharactersUseCase: FetchCharactersUseCase = {
        FetchCharactersServiceUseCase(service: charactersService)
    }()
}

private extension CharactersDependencyContainer {

    var charactersService: CharactersService {
        switch dependencies.scheme {
        case .debug:
            return CharactersDebugService(dataLoader: JsonDecoderDataLoader(parser: parser))
        case .release:
            return CharactersClientService(client: dependencies.networkService, parser: parser)
        }
    }

    var parser: JSONParser {
        JSONDecoderParser()
    }
}
