//
//  CollectionViewDelegateMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 6/2/22.
//

import Foundation
import UIKit

class CollectionViewDelegateMock: NSObject, UICollectionViewDelegate {
    var willDisplayCellCallCount = 0

    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt _: IndexPath) {
        willDisplayCellCallCount += 1
    }
}
