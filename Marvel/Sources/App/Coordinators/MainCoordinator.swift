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

    func createCharactersViewController() -> UIViewController {
        // TODO: Move viewController instantiation and dependency wiring to some kind of factory
        let viewController = CharactersViewController()
        let viewModel = CharactersViewModel()
        let charactersDataSource = CharactersDataSource(viewModel: viewModel)
        viewController.dataSource = charactersDataSource
        viewController.layout = CharactersLayout()
        viewController.delegate = charactersDataSource
        return viewController
    }
}
