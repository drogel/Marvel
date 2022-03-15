//
//  CollectionViewDataSource.swift
//  Marvel
//
//  Created by Diego Rogel on 3/2/22.
//

import UIKit

protocol CollectionViewDataSource {
    func setDataSource(of collectionView: UICollectionView)
    func update<T: Hashable>(with items: [T])
}
