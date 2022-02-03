//
//  CharacterDetailLayout.swift
//  Marvel
//
//  Created by Diego Rogel on 3/2/22.
//

import Foundation
import UIKit

class CharacterDetailLayout: UICollectionViewCompositionalLayout {
    private static var sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { sectionIndex, _ in
        let section = CharacterDetailSection.fromSectionIndex(sectionIndex)
        switch section {
        case .image:
            return CharacterImageSection()
        case .info:
            return CharacterInfoSection()
        }
    }

    init() {
        super.init(sectionProvider: Self.sectionProvider)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Initialization of \(String(describing: CharactersLayout.self)) through coder not supported")
    }
}
