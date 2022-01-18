//
//  CharactersViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Foundation

protocol CharactersViewModelProtocol {
    func select(itemAt indexPath: IndexPath)
}

class CharactersViewModel: CharactersViewModelProtocol {
    func select(itemAt indexPath: IndexPath) { }
}
