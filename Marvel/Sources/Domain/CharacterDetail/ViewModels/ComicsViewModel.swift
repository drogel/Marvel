//
//  ComicsViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation

protocol ComicsViewModelProtocol: ViewModel {}

protocol ComicsViewModelViewDelegate: AnyObject {
    func viewModelDidStartLoading(_ viewModel: ComicsViewModelProtocol)
}

class ComicsViewModel: ComicsViewModelProtocol {
    weak var viewDelegate: ComicsViewModelViewDelegate?

    func start() {
        viewDelegate?.viewModelDidStartLoading(self)
    }

    func dispose() { }
}
