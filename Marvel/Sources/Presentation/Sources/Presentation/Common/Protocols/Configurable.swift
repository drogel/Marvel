//
//  Configurable.swift
//  Marvel
//
//  Created by Diego Rogel on 20/1/22.
//

import Foundation
import UIKit

typealias ConfigurableCell = UICollectionViewCell & Configurable

typealias ConfigurableReusableView = UICollectionReusableView & Configurable

protocol Configurable {
    associatedtype Item

    func configure(using item: Item)
}
