//
//  UICollectionReusableView+Identifiable.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

extension UICollectionReusableView: Identifiable {
    static var identifier: String {
        String(describing: self)
    }
}
