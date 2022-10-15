//
//  NSLayoutConstraints+Fitting.swift
//  Marvel
//
//  Created by Diego Rogel on 2/2/22.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    static func fit(_ innerView: UIView, in outerView: UIView, inset: CGFloat = 0) {
        innerView.translatesAutoresizingMaskIntoConstraints = false
        activate([
            innerView.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: inset),
            innerView.topAnchor.constraint(equalTo: outerView.topAnchor, constant: inset),
            innerView.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -inset),
            innerView.bottomAnchor.constraint(equalTo: outerView.bottomAnchor, constant: -inset),
        ])
    }
}
