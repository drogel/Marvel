//
//  SceneDelegate.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let appDependencyContainer = MarvelDependencyContainer(configuration: MarvelConfigurationValues())
    private var coordinator: Coordinator?

    // TODO: Sort Xcode project folders by type and name.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        coordinator = MainCoordinator(navigationController: UINavigationController(), dependencyContainer: appDependencyContainer)
        coordinator?.start()
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = coordinator?.navigationController
        window?.makeKeyAndVisible()
    }
}
