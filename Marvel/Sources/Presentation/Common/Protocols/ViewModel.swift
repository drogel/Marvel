//
//  ViewModel.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

protocol ViewModel: Disposable {
    func start() async
}
