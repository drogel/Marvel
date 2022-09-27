//
//  CharactersDependencyContainer.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Data
import Domain
import Factory
import Foundation
import Presentation

struct CharactersDependenciesAdapter: CharactersDependencies {
    let fetchCharactersUseCase: FetchCharactersUseCase
    let imageURLBuilder: ImageURLBuilder
    let pager: Pager
}

final class CharactersContainer: MarvelDepencyContainer {
    static let charactersContainer = Factory<CharactersDependencies> {
        CharactersDependenciesAdapter(
            fetchCharactersUseCase: FetchCharactersUseCaseFactory.create(service: charactersService()),
            imageURLBuilder: ImageURLBuilderFactory.create(),
            pager: PagerFactory.create()
        )
    }
}

private extension CharactersContainer {
    static let charactersService = Factory<CharactersService> {
        let dependencies = appDependencyContainer()
        switch dependencies.scheme {
        case .debug:
            return CharactersServiceFactory.createDebug()
        case .stage, .release:
            return CharactersServiceFactory.create(with: dependencies.baseApiURL)
        }
    }
}
