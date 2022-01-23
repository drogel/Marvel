//
//  Instantiable.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

protocol ViewModelInstantiable {
    associatedtype ViewModel
    static func instantiate(viewModel: ViewModel) -> Self
}
