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
        let charactersViewController = createCharactersViewController()
        navigationController.pushViewController(charactersViewController, animated: false)
    }
}

private extension MainCoordinator {

    func createCharactersViewController() -> UIViewController {
        // TODO: Move viewController instantiation to some kind of factory
        let viewController = CharactersViewController()
        viewController.dataSource = CharactersDataSource()
        viewController.layout = CharactersLayout()
        return viewController
    }
}
