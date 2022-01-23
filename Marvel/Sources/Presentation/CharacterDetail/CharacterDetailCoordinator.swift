//
//  CharacterDetailCoordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
import UIKit

class CharacterDetailCoordinator: Coordinator {

    var children: [Coordinator]
    let navigationController: UINavigationController

    private let container: CharacterDetailContainer

    init(navigationController: UINavigationController, container: CharacterDetailContainer) {
        self.navigationController = navigationController
        self.container = container
        self.children = []
    }

    func start() {
        showCharacterDetailViewController()
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
        viewModel.viewDelegate = viewController
        return viewController
    }
}
