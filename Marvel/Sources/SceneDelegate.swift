//
//  SceneDelegate.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import App
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private var mainStartable: Startable!

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        setUpWindow(with: navigationController, in: scene)
        mainStartable = MainStartableFactory.create(with: navigationController)
        mainStartable.start()
    }
}

private extension SceneDelegate {
    func setUpWindow(with navigationController: UINavigationController, in scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
