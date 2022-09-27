//
//  MainCoordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Foundation

public enum MainStartableFactory {
    public static func create(with navigationController: NavigationController) -> Startable {
        MainCoordinator(navigationController: navigationController)
    }
}

class MainCoordinator: Coordinator {
    weak var delegate: CoordinatorDelegate?
    var children: [Coordinator]

    private let navigationController: NavigationController

    init(navigationController: NavigationController) {
        self.navigationController = navigationController
        children = []
    }

    func start() {
        showCharacters()
    }
}

private extension MainCoordinator {
    func showCharacters() {
        let charactersCoordinator = CharactersCoordinator(navigationController: navigationController)
        charactersCoordinator.start()
        children.append(charactersCoordinator)
    }
}
