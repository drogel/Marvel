//
//  CollectionViewDataSource.swift
//  Marvel
//
//  Created by Diego Rogel on 3/2/22.
//

import Foundation
import UIKit

protocol CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    func registerSubviews(in collectionView: UICollectionView)
}
