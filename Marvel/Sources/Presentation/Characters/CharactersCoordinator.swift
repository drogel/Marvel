//
//  CharactersCoordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation
import UIKit

class CharactersCoordinator: Coordinator {
    var children: [Coordinator]
    let navigationController: UINavigationController

    private let container: CharactersContainer

    init(navigationController: UINavigationController, container: CharactersContainer) {
        self.navigationController = navigationController
        self.container = container
        self.children = []
    }

    func start() {
        showCharactersViewController()
    }
}

private extension CharactersCoordinator {

    func showCharactersViewController() {
        let charactersViewController = createCharactersViewController()
        navigationController.pushViewController(charactersViewController, animated: false)
    }

    func createCharactersViewController() -> UIViewController {
        let viewModel = CharactersViewModel(charactersFetcher: container.fetchCharactersUseCase)
        let viewController = CharactersViewController.instantiate(viewModel: viewModel, layout: CharactersLayout())
        viewModel.coordinatorDelegate = self
        viewModel.viewDelegate = viewController
        return viewController
    }

    func showCharacterDetailViewController() {
        let characterDetailViewController = createCharacterDetailViewController()
        navigationController.present(characterDetailViewController, animated: true)
    }

    func createCharacterDetailViewController() -> UIViewController {
        // TODO: Move viewController instantiation and dependency wiring to some kind of factory
        // TODO: Implement actual characterID passing to view model
        let characterDetailService = CharacterDetailDebugService(dataLoader: JsonDecoderDataLoader(parser: JSONDecoderParser()))
        let characterDetailFetcher = FetchCharacterDetailServiceUseCase(service: characterDetailService)
        let viewModel = CharacterDetailViewModel(characterFetcher: characterDetailFetcher, characterID: 1011334)
        return CharacterDetailViewController.instantiate(viewModel: viewModel)
    }
}

extension CharactersCoordinator: CharactersViewModelCoordinatorDelegate {

    func viewModel(_ viewModel: CharactersViewModelProtocol, didSelectItemAt indexPath: IndexPath) {
        showCharacterDetailViewController()
    }
}
