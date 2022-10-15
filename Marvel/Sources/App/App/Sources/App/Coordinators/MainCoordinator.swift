//
//  MainCoordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Foundation

public enum MainStartableFactory {
    public static func create(with navigationController: NavigationController) -> Startable {
        let appDependencyContainer = MarvelDependencyContainer(configuration: MarvelConfigurationValues())
        return MainCoordinator(navigationController: navigationController, dependencyContainer: appDependencyContainer)
    }
}

class MainCoordinator: Coordinator {
    weak var delegate: CoordinatorDelegate?
    var children: [Coordinator]

    private let navigationController: NavigationController
    private let dependencyContainer: AppDependencyContainer

    init(navigationController: NavigationController, dependencyContainer: AppDependencyContainer) {
        self.navigationController = navigationController
        children = []
        self.dependencyContainer = dependencyContainer
    }

    func start() {
        showCharacters()
    }
}

private extension MainCoordinator {
    func showCharacters() {
        let charactersDependencies = CharactersDependenciesAdapter(
            baseApiURL: dependencyContainer.baseApiURL,
            scheme: dependencyContainer.scheme
        )
        let charactersCoordinator = CharactersCoordinator(
            navigationController: navigationController,
            dependencies: charactersDependencies
        )
        charactersCoordinator.start()
        children.append(charactersCoordinator)
    }
}
