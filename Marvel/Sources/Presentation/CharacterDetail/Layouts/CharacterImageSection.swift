//
//  CharacterImageSection.swift
//  Marvel
//
//  Created by Diego Rogel on 3/2/22.
//

import Foundation
import UIKit

class CharacterImageSection: NSCollectionLayoutSection {
    private enum Constants {
        static let imageHeight: NSCollectionLayoutDimension = .fractionalHeight(0.618)
    }

    convenience init() {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: Constants.imageHeight
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: Constants.imageHeight
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        self.init(group: group)
    }
}
