//
//  Configurable.swift
//  Marvel
//
//  Created by Diego Rogel on 20/1/22.
//

import Foundation

protocol Configurable {

    associatedtype Item

    func configure(using item: Item)
}
