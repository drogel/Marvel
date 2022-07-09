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
            return CharacterDetailServiceFactory.createDebug()
        case .stage, .release:
            return CharacterDetailServiceFactory.create(with: dependencies.networkService)
        }
    }

    var comicsDetailService: ComicsService {
        switch dependencies.scheme {
        case .debug:
            return ComicsServiceFactory.createDebug()
        case .stage, .release:
            return ComicsServiceFactory.create(with: dependencies.networkService)
        }
    }
}
