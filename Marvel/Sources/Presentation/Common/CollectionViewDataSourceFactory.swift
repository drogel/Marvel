//
//  CollectionViewDataSourceFactory.swift
//  Marvel
//
//  Created by Diego Rogel on 6/3/22.
//

import UIKit

protocol CollectionViewDataSourceFactory {
    func create(collectionView: UICollectionView) -> CollectionViewDataSource
}
