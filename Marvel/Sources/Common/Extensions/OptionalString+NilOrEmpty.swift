//
//  OptionalString+NilOrEmpty.swift
//  Marvel
//
//  Created by Diego Rogel on 3/2/22.
//

import Foundation

extension Optional where Wrapped == String {

    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
