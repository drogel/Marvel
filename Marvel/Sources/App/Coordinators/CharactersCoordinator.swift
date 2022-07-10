//
//  CharactersCoordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation
import Presentation
import UIKit

class CharactersCoordinator: Coordinator {
    weak var delegate: CoordinatorDelegate?
    var children: [Coordinator]

    private let navigationController: UINavigationController
    private let dependencies: CharactersDependencies

    init(navigationController: UINavigationController, dependencies: CharactersDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        children = []
    }

    func start() {
        showCharactersViewController()
    }
}

extension CharactersCoordinator: CharactersViewModelCoordinatorDelegate {
    func model(didSelectCharacterWith characterID: Int) {
        let characterDetailContainer = CharacterDetailDependencyContainer(
            dependencies: dependencies,
            characterID: characterID
        )
        let characterDetailCoordinator = CharacterDetailCoordinator(
            navigationController: navigationController,
            container: characterDetailContainer
        )
        characterDetailCoordinator.delegate = self
        characterDetailCoordinator.start()
        children.append(characterDetailCoordinator)
    }
}

private extension CharactersCoordinator {
    func showCharactersViewController() {
        let charactersViewController = createCharactersViewController()
        navigationController.pushViewController(charactersViewController, animated: false)
    }

    func createCharactersViewController() -> UIViewController {
        let charactersContainer = CharactersDependencyContainer(dependencies: dependencies)
        return CharactersViewControllerFactory.create(using: charactersContainer, delegate: self)
    }
}
