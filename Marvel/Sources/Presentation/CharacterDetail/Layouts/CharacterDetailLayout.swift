//
//  CharacterDetailLayout.swift
//  Marvel
//
//  Created by Diego Rogel on 3/2/22.
//

import Foundation
import UIKit

class CharacterDetailLayout: UICollectionViewCompositionalLayout {
    private enum Constants {
        static let spacing: CGFloat = 18
        static let imageHeight: NSCollectionLayoutDimension = .fractionalHeight(0.618)
        static let infoHeight: NSCollectionLayoutDimension = .estimated(200)
    }

    private static var sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { sectionIndex, _ in
        let section = CharacterDetailSection.fromSectionIndex(sectionIndex)
        switch section {
        case .image:
            return CharacterDetailLayout.imageSection()
        case .info:
            return CharacterDetailLayout.infoSection()
        }
    }

    init() {
        super.init(sectionProvider: Self.sectionProvider)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Initialization of \(String(describing: CharactersLayout.self)) through coder not supported")
    }

    private static func imageSection() -> NSCollectionLayoutSection {
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
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    private static func infoSection() -> NSCollectionLayoutSection {
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
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
