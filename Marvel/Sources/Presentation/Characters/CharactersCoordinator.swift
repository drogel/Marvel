//
//  CharactersCoordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation
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

extension CharactersCoordinator: CharactersPresentationModelCoordinatorDelegate {
    func model(_: CharactersPresentationModelProtocol, didSelectCharacterWith characterID: Int) {
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
        let presentationModel = CharactersPresentationModel(
            charactersFetcher: charactersContainer.fetchCharactersUseCase,
            imageURLBuilder: charactersContainer.imageURLBuilder,
            pager: charactersContainer.pager
        )
        let viewController = CharactersViewController.instantiate(
            presentationModel: presentationModel,
            layout: CharactersLayout()
        )
        presentationModel.coordinatorDelegate = self
        presentationModel.viewDelegate = viewController
        return viewController
    }
}
