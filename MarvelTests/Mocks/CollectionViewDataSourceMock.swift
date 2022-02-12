//
//  CollectionViewDataSourceMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 3/2/22.
//

import Foundation
@testable import Marvel_Debug
import UIKit

class CollectionViewDataSourceMock: NSObject, CollectionViewDataSource {
    var registerSubviewsCallCount = 0
    var numberOfItemsInSectionCallCount = 0
    var cellForItemAtCallCount = 0

    func registerSubviews(in _: UICollectionView) {
        registerSubviewsCallCount += 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        numberOfItemsInSectionCallCount += 1
        return 0
    }

    func collectionView(_: UICollectionView, cellForItemAt _: IndexPath) -> UICollectionViewCell {
        cellForItemAtCallCount += 1
        return UICollectionViewCell()
    }
}
