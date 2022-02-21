//
//  UICollectionView+Dequeue.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation
import UIKit

extension UICollectionView {
    func dequeue<T: UICollectionReusableView>(cellOfType _: T.Type, at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Failed dequeuing a cell with identifier \(T.identifier) and type \(String(describing: T.self))")
        }
        return cell
    }

    func dequeue<T: UICollectionReusableView>(headerOfType _: T.Type, at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.identifier,
            for: indexPath
        ) as? T
        else {
            fatalError("Failed dequeuing header with identifier \(T.identifier) and type \(String(describing: T.self))")
        }
        return cell
    }
}
