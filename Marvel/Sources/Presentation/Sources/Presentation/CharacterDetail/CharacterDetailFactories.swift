//
//  CharacterDetailFactories.swift
//
//
//  Created by Diego Rogel on 10/7/22.
//

import Domain
import Foundation
import UIKit

public protocol CharacterDetailDependencies {
    var characterID: Int { get }
    var fetchCharacterDetailUseCase: FetchCharacterDetailUseCase { get }
    var fetchComicsUseCase: FetchComicsUseCase { get }
    var imageURLBuilder: ImageURLBuilder { get }
    var pager: Pager { get }
}

public enum CharacterDetailViewControllerFactory {
    public static func create(with container: CharacterDetailDependencies) -> UIViewController {
        let infoViewModel = CharacterInfoViewModel(
            characterFetcher: container.fetchCharacterDetailUseCase,
            characterID: container.characterID,
            imageURLBuilder: container.imageURLBuilder
        )
        let comicsViewModel = ComicsViewModel(
            comicsFetcher: container.fetchComicsUseCase,
            characterID: container.characterID,
            imageURLBuilder: container.imageURLBuilder,
            pager: container.pager
        )
        let viewModel = CharacterDetailViewModel(
            infoViewModel: infoViewModel,
            comicsViewModel: comicsViewModel
        )
        let viewController = CharacterDetailViewController.instantiate(
            viewModel: viewModel,
            layout: CharacterDetailLayout(),
            dataSourceFactory: CharacterDetailDataSourceFactory(viewModel: viewModel)
        )
        return viewController
    }
}
