//
//  UICollectionViewStub.swift
//  MarvelTests
//
//  Created by Diego Rogel on 3/2/22.
//

import Foundation
import UIKit

class UICollectionViewStub: UICollectionView {

    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    }

    required init?(coder: NSCoder) {
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    }
}
