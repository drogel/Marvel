//
//  SceneDelegate.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createWindowRootViewController()
        window?.makeKeyAndVisible()
    }
}

private extension SceneDelegate {

    private func createWindowRootViewController() -> UIViewController {
        // TODO: Move viewController instantiation out of here
        let viewController = CharactersViewController()
        viewController.dataSource = CharactersDataSource()
        viewController.layout = CharactersLayout()
        return UINavigationController(rootViewController: viewController)
    }
}
