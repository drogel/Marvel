//
//  LoadingViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController {
    enum Constants {
        static let animationDuration = 0.35
    }

    private let spinnerChild = SpinnerViewController()
}

extension LoadingViewController: Loadable {
    func startLoading() {
        animateSpinnerShowing()
    }

    func stopLoading() {
        animateSpinnerDisappearing()
    }
}

private extension LoadingViewController {
    func animateSpinnerShowing() {
        hideSpinner()
        addSpinnerToView()
        animate { self.showSpinner() }
    }

    func animateSpinnerDisappearing() {
        animate {
            self.hideSpinner()
        } completion: {
            self.removeSpinnerFromView()
        }
    }

    func hideSpinner() {
        spinnerChild.view.alpha = 0
    }

    func showSpinner() {
        spinnerChild.view.alpha = 1
    }

    func addSpinnerToView() {
        addChild(spinnerChild)
        spinnerChild.view.frame = view.frame
        view.addSubview(spinnerChild.view)
        spinnerChild.didMove(toParent: self)
    }

    func removeSpinnerFromView() {
        spinnerChild.willMove(toParent: nil)
        spinnerChild.view.removeFromSuperview()
        spinnerChild.removeFromParent()
    }

    func animate(animations: @escaping () -> Void, completion: (() -> Void)? = nil) {
        // TODO: Get rid of this when we complete async await migration
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: Constants.animationDuration,
                delay: 0,
                options: .curveEaseOut,
                animations: animations,
                completion: { _ in completion?() }
            )
        }
    }
}
