//
//  CharacterDetailDependencyContainer.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Data
import Domain
import Factory
import Foundation
import Presentation

struct CharacterDetailDependenciesAdapter: CharacterDetailDependencies {
    let characterID: Int
    let fetchCharacterDetailUseCase: FetchCharacterDetailUseCase
    let fetchComicsUseCase: FetchComicsUseCase
    let imageURLBuilder: ImageURLBuilder
    let pager: Pager
}

final class CharacterDetailContainer: MarvelDepencyContainer {
    static let characterDetailContainer = ParameterFactory<Int, CharacterDetailDependencies> { characterId in
        CharacterDetailDependenciesAdapter(
            characterID: characterId,
            fetchCharacterDetailUseCase: FetchCharacterDetailUseCaseFactory.create(service: characterDetailService()),
            fetchComicsUseCase: FetchComicsUseCaseFactory.create(service: comicsDetailService()),
            imageURLBuilder: ImageURLBuilderFactory.create(),
            pager: PagerFactory.create()
        )
    }
}

private extension CharacterDetailContainer {
    static let characterDetailService = Factory<CharacterDetailService> {
        let dependencies = appDependencyContainer()
        switch dependencies.scheme {
        case .debug:
            return CharacterDetailServiceFactory.createDebug()
        case .stage, .release:
            return CharacterDetailServiceFactory.create(with: dependencies.baseApiURL)
        }
    }

    static let comicsDetailService = Factory<ComicsService> {
        let dependencies = appDependencyContainer()
        switch dependencies.scheme {
        case .debug:
            return ComicsServiceFactory.createDebug()
        case .stage, .release:
            return ComicsServiceFactory.create(with: dependencies.baseApiURL)
        }
    }
}
