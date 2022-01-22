//
//  ViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    enum Constants {
        static let animationDuration = 0.35
    }

    let spinnerChild = SpinnerViewController()
}

extension ViewController: Loadable {

    func startLoading() {
        animateSpinnerShowing()
    }

    func stopLoading() {
        animateSpinnerDisappearing()
    }
}

private extension ViewController {

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
        UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: .curveEaseOut, animations: animations, completion: { _ in completion?() })
    }
}
