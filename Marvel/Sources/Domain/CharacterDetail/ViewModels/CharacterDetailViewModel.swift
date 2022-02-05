//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation

protocol CharacterDetailViewModelProtocol: ViewModel {}

class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    private var infoViewModel: CharacterDetailInfoViewModelProtocol
    private var comicsViewModel: ComicsViewModelProtocol

    init(infoViewModel: CharacterDetailInfoViewModelProtocol, comicsViewModel: ComicsViewModelProtocol) {
        self.infoViewModel = infoViewModel
        self.comicsViewModel = comicsViewModel
    }

    func start() {
        infoViewModel.start()
        comicsViewModel.start()
    }

    func dispose() {
        infoViewModel.dispose()
        comicsViewModel.dispose()
    }
}
