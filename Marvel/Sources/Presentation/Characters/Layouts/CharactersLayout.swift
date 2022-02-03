//
//  CharactersLayout.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

class CharactersLayout: UICollectionViewCompositionalLayout {
    private static var sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { _, _ in
        CharactersSection()
    }

    init() {
        super.init(sectionProvider: Self.sectionProvider)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Initialization of \(String(describing: CharactersLayout.self)) through coder not supported")
    }
}
