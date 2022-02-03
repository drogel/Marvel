//
//  CharacterInfoSection.swift
//  Marvel
//
//  Created by Diego Rogel on 3/2/22.
//

import Foundation
import UIKit

class CharacterInfoSection: NSCollectionLayoutSection {
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
        item.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.spacing,
            leading: Constants.spacing,
            bottom: Constants.spacing,
            trailing: Constants.spacing
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: Constants.infoHeight
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        self.init(group: group)
    }
}
