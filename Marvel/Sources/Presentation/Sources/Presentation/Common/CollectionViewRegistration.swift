//
//  CollectionViewRegistration.swift
//  Marvel
//
//  Created by Diego Rogel on 6/3/22.
//

import UIKit

typealias CellRegistration<Cell: ConfigurableCell> = UICollectionView.CellRegistration<Cell, Cell.Item>

typealias SupplementaryRegistration<R: ConfigurableReusableView> = UICollectionView.SupplementaryRegistration<R>

extension SupplementaryRegistration {
    static func header(
        handler: @escaping SupplementaryRegistration<Supplementary>.Handler
    ) -> SupplementaryRegistration<Supplementary> {
        SupplementaryRegistration<Supplementary>(
            elementKind: UICollectionView.elementKindSectionHeader,
            handler: handler
        )
    }
}
