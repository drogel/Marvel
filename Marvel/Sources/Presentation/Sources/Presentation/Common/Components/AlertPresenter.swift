//
//  AlertPresenter.swift
//  Marvel
//
//  Created by Diego Rogel on 24/1/22.
//

import Foundation
import UIKit

protocol AlertPresenter {
    func showAlert(title: String, message: String, buttonTitle: String, buttonAction: (() -> Void)?)
    func showErrorAlert(message: String, retryButtonAction: (() -> Void)?)
}

extension AlertPresenter where Self: UIViewController {
    func showErrorAlert(message: String, retryButtonAction: (() -> Void)? = nil) {
        showAlert(
            title: "error".localized,
            message: message,
            buttonTitle: "retry".localized,
            buttonAction: retryButtonAction
        )
    }

    func showAlert(title: String, message: String, buttonTitle: String, buttonAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { _ in buttonAction?() }))
        present(alert, animated: true)
    }
}
