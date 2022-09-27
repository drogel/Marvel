//
//  CharactersCoordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Factory
import Foundation
import Presentation
import UIKit

class CharactersCoordinator: Coordinator {
    weak var delegate: CoordinatorDelegate?
    var children: [Coordinator]

    private let navigationController: NavigationController
    @Injected(CharactersContainer.charactersContainer) private var container: CharactersDependencies

    init(navigationController: NavigationController) {
        self.navigationController = navigationController
        children = []
    }

    func start() {
        showCharactersViewController()
    }
}

extension CharactersCoordinator: CharactersViewModelCoordinatorDelegate {
    func model(didSelectCharacterWith characterID: Int) {
        let characterDetailCoordinator = CharacterDetailCoordinator(
            navigationController: navigationController,
            characterID: characterID
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
        CharactersViewControllerFactory.create(using: container, delegate: self)
    }
}
