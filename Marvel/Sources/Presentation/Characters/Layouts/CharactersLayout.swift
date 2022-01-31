//
//  CharactersLayout.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class CharactersLayout: UICollectionViewCompositionalLayout {
    private enum Constants {
        static let spacing: CGFloat = 18
        static let itemHeight: CGFloat = 300
    }

    private static var sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { _, _ in
        CharactersLayout.buildSingleListSection()
    }

    init() {
        super.init(sectionProvider: Self.sectionProvider)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Initialization of \(String(describing: CharactersLayout.self)) through coder not supported")
    }

    private static func buildSingleListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Constants.itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: Constants.spacing, leading: Constants.spacing, bottom: Constants.spacing, trailing: Constants.spacing)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(Constants.itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
