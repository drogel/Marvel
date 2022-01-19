//
//  MainCoordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class MainCoordinator: Coordinator {
    let children: [Coordinator] = []
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showCharactersViewController()
    }
}

private extension MainCoordinator {

    func showCharactersViewController() {
        let charactersViewController = createCharactersViewController()
        navigationController.pushViewController(charactersViewController, animated: false)
    }

    func showCharacterDetailViewController() {
        let characterDetailViewController = createCharacterDetailViewController()
        navigationController.present(characterDetailViewController, animated: true)
    }

    func createCharactersViewController() -> UIViewController {
        // TODO: Move viewController instantiation and dependency wiring to some kind of factory
        let viewController = CharactersViewController()
        // TODO: Remove this temporary service injection
        let charactersService = CharactersDebugService(dataLoader: JsonDataLoader())
        let fetchCharactersUseCase = FetchCharactersUseCase(service: charactersService)
        let viewModel = CharactersViewModel(charactersFetcher: fetchCharactersUseCase)
        viewModel.coordinatorDelegate = self
        let charactersDataSource = CharactersDataSource(viewModel: viewModel)
        viewController.dataSource = charactersDataSource
        viewController.layout = CharactersLayout()
        viewController.delegate = charactersDataSource
        return viewController
    }

    func createCharacterDetailViewController() -> UIViewController {
        // TODO: Move viewController instantiation and dependency wiring to some kind of factory
        return CharacterDetailViewController()
    }
}

extension MainCoordinator: CharactersViewModelCoordinatorDelegate {
    func viewModel(_ viewModel: CharactersViewModelProtocol, didSelectItemAt indexPath: IndexPath) {
        showCharacterDetailViewController()
    }
}
