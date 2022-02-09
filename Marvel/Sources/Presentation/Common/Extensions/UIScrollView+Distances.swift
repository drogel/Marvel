//
//  UIScrollView+Distances.swift
//  Marvel
//
//  Created by Diego Rogel on 9/2/22.
//

import Foundation
import UIKit

extension UIScrollView {
    var offsetDistanceToBottom: CGFloat {
        let contentYOffset = contentOffset.y
        let contentHeight = contentSize.height
        return contentHeight - contentYOffset
    }
}
