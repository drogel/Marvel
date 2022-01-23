//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class CharacterDetailViewController: ViewController {

    typealias ViewModel = CharacterDetailViewModelProtocol

    private var viewModel: ViewModel!

    static func instantiate(viewModel: ViewModel) -> Self {
        let viewController = CharacterDetailViewController()
        viewController.viewModel = viewModel
        return viewController as! Self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
        // TODO: Remove background color set, this is just for testing purposes
        view.backgroundColor = .systemRed
    }
}

extension CharacterDetailViewController: Configurable {

    typealias Item = CharacterDetailData

    func configure(using item: CharacterDetailData) {
        // TODO: Implement
    }
}

extension CharacterDetailViewController: CharacterDetailViewModelViewDelegate {

    func viewModelDidStartLoading(_ viewModel: CharacterDetailViewModelProtocol) {
        startLoading()
    }

    func viewModelDidFinishLoading(_ viewModel: CharacterDetailViewModelProtocol) {
        stopLoading()
    }

    func viewModel(_ viewModel: CharacterDetailViewModelProtocol, didRetrieve characterDetail: CharacterDetailData) {
        configure(using: characterDetail)
    }
}

