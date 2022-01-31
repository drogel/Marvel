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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navigationController, dependencyContainer: appDependencyContainer)
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        coordinator?.start()
    }
}
