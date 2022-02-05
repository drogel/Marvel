//
//  UICollectionView+CellRegistration.swift
//  Marvel
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation
import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellOfType cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: T.identifier)
    }
}
