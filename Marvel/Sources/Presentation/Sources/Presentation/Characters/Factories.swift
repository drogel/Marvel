//
//  Factories.swift
//
//
//  Created by Diego Rogel on 10/7/22.
//

import Domain
import Foundation
import UIKit

public protocol CharactersContainer {
    var fetchCharactersUseCase: FetchCharactersUseCase { get }
    var imageURLBuilder: ImageURLBuilder { get }
    var pager: Pager { get }
}

public enum CharactersViewControllerFactory {
    public static func create(
        using container: CharactersContainer,
        delegate: CharactersViewModelCoordinatorDelegate
    ) -> UIViewController {
        let viewModel = CharactersViewModel(
            charactersFetcher: container.fetchCharactersUseCase,
            imageURLBuilder: container.imageURLBuilder,
            pager: container.pager
        )
        let viewController = CharactersViewController.instantiate(
            viewModel: viewModel,
            layout: CharactersLayout(),
            dataSourceFactory: CharactersDataSourceFactory()
        )
        viewModel.coordinatorDelegate = delegate
        return viewController
    }
}
