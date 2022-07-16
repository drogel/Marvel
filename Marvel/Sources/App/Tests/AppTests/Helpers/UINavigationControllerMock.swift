//
//  UINavigationControllerMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 1/2/22.
//

import Foundation
import UIKit

class UINavigationControllerMock: UINavigationController {
    var mostRecentPresentedViewController: UIViewController?

    override func present(
        _ viewControllerToPresent: UIViewController,
        animated _: Bool,
        completion: (() -> Void)? = nil
    ) {
        mostRecentPresentedViewController = viewControllerToPresent
        super.present(viewControllerToPresent, animated: false, completion: completion)
    }

    override func pushViewController(_ viewController: UIViewController, animated _: Bool) {
        super.pushViewController(viewController, animated: false)
    }
}
