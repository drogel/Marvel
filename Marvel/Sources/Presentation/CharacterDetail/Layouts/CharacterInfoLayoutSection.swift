//
//  CharacterInfoSection.swift
//  Marvel
//
//  Created by Diego Rogel on 3/2/22.
//

import Foundation
import UIKit

class CharacterInfoLayoutSection: NSCollectionLayoutSection {
    private enum Constants {
        static let spacing: CGFloat = 18
        static let infoHeight: NSCollectionLayoutDimension = .estimated(200)
    }

    convenience init() {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: Constants.infoHeight
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: Constants.infoHeight
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(Constants.spacing)
        self.init(group: group)
    }
}
