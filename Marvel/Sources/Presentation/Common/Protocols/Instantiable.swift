//
//  Instantiable.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

protocol ViewModelInstantiable {
    associatedtype ViewModelProtocol
    static func instantiate(viewModel: ViewModelProtocol) -> Self
}
