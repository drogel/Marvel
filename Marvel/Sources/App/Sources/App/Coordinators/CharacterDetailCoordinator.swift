//
//  CharacterDetailCoordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
import Presentation
import UIKit

class CharacterDetailCoordinator: NSObject, Coordinator {
    weak var delegate: CoordinatorDelegate?
    var children: [Coordinator]

    private let navigationController: NavigationController
    private let container: CharacterDetailDependencies

    init(navigationController: NavigationController, characterID: Int) {
        self.navigationController = navigationController
        container = CharacterDetailContainer.characterDetailContainer(characterID)
        children = []
    }

    func start() {
        showCharacterDetailViewController()
    }
}

extension CharacterDetailCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard dismissed is CharacterDetailViewController else { return nil }
        delegate?.coordinatorDidFinish(self)
        return nil
    }
}

private extension CharacterDetailCoordinator {
    func showCharacterDetailViewController() {
        let characterDetailViewController = createCharacterDetailViewController()
        navigationController.present(characterDetailViewController, animated: true)
    }

    func createCharacterDetailViewController() -> UIViewController {
        let viewController = CharacterDetailViewControllerFactory.create(with: container)
        viewController.transitioningDelegate = self
        return viewController
    }
}
