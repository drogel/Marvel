//
//  ComicsLayoutSection.swift
//  Marvel
//
//  Created by Diego Rogel on 6/2/22.
//

import Foundation
import UIKit

class ComicsLayoutSection: NSCollectionLayoutSection {
    // TODO: Fix layout issues when scrolling
    private enum Constants {
        static let height: NSCollectionLayoutDimension = .estimated(266)
        static let width: NSCollectionLayoutDimension = .fractionalWidth(0.375)
        static let itemInset: CGFloat = 8
        static let layoutInset: CGFloat = 14
    }

    convenience init() {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: Constants.height
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: Constants.width,
            heightDimension: Constants.height
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(Constants.itemInset),
            top: .fixed(Constants.itemInset),
            trailing: .fixed(Constants.itemInset),
            bottom: .fixed(Constants.itemInset)
        )
        self.init(group: group)
        orthogonalScrollingBehavior = .continuous
        contentInsets = NSDirectionalEdgeInsets(
            top: Constants.layoutInset,
            leading: Constants.layoutInset,
            bottom: Constants.layoutInset,
            trailing: Constants.layoutInset
        )
    }
}
