//
//  String+Localized.swift
//  Marvel
//
//  Created by Diego Rogel on 31/1/22.
//

import Foundation

public extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
