//
//  SpinnerViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import UIKit

class SpinnerViewController: UIViewController {

    let spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        setUpSubviews()
    }
}

private extension SpinnerViewController {

    func setUpBackgroundView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.8)
    }

    func setUpSubviews() {
        setUpBackgroundView()
        setUpSpinnerView()
        setUpSpinnerConstraints()
    }

    func setUpSpinnerView() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
    }

    func setUpSpinnerConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
