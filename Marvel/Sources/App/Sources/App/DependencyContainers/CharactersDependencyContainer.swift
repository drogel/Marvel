//
//  CharactersDependencyContainer.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Data
import Domain
import Foundation
import Presentation

protocol CharactersDependencies {
    var baseApiURL: URL { get }
    var scheme: AppScheme { get }
}

class CharactersDependenciesAdapter: CharactersDependencies {
    let baseApiURL: URL
    let scheme: AppScheme

    init(baseApiURL: URL, scheme: AppScheme) {
        self.baseApiURL = baseApiURL
        self.scheme = scheme
    }
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
            return CharactersServiceFactory.createDebug()
        case .stage, .release:
            return CharactersServiceFactory.create(with: dependencies.baseApiURL)
        }
    }
}
