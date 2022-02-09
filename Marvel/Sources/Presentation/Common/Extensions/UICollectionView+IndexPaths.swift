//
//  UICollectionView+IndexPaths.swift
//  Marvel
//
//  Created by Diego Rogel on 9/2/22.
//

import Foundation
import UIKit

extension UICollectionView {
    func indexPathForCellAtBoundsEdge(of contentOffset: CGPoint) -> IndexPath? {
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let visibleRectCenter = CGPoint(x: visibleRect.midX, y: visibleRect.maxY)
        return indexPathForItem(at: visibleRectCenter)
    }
}
