//
//  MainCoordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class MainCoordinator: Coordinator {

    var delegate: CoordinatorDelegate?
    var children: [Coordinator]

    private let navigationController: UINavigationController
    private let dependencyContainer: AppDependencyContainer

    init(navigationController: UINavigationController, dependencyContainer: AppDependencyContainer) {
        self.navigationController = navigationController
        self.children = []
        self.dependencyContainer = dependencyContainer
    }

    func start() {
        showCharacters()
    }
}

private extension MainCoordinator {

    func showCharacters() {
        let charactersDependencies = CharactersDependenciesAdapter(networkService: dependencyContainer.networkService, scheme: dependencyContainer.scheme)
        let charactersCoordinator = CharactersCoordinator(navigationController: navigationController, dependencies: charactersDependencies)
        charactersCoordinator.start()
        children.append(charactersCoordinator)
    }
}
