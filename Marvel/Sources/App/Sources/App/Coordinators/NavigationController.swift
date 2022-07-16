//
//  NavigationController.swift
//
//
//  Created by Diego Rogel on 16/7/22.
//

import Foundation
import UIKit

public protocol NavigationController {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

extension NavigationController {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool) {
        present(viewControllerToPresent, animated: flag, completion: nil)
    }
}

extension UINavigationController: NavigationController {}
