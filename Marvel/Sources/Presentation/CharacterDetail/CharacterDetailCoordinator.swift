//
//  CharacterDetailCoordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
import UIKit

class CharacterDetailCoordinator: NSObject, Coordinator {
    weak var delegate: CoordinatorDelegate?
    var children: [Coordinator]

    private let navigationController: UINavigationController
    private let container: CharacterDetailContainer

    init(navigationController: UINavigationController, container: CharacterDetailContainer) {
        self.navigationController = navigationController
        self.container = container
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
        let viewModel = CharacterDetailViewModel(characterFetcher: container.fetchCharacterDetailUseCase, characterID: container.characterID)
        let viewController = CharacterDetailViewController.instantiate(viewModel: viewModel)
        viewController.transitioningDelegate = self
        viewModel.viewDelegate = viewController
        return viewController
    }
}
