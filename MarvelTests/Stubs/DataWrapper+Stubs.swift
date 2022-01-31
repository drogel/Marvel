//
//  DataWrapper+Stubs.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation
@testable import Marvel_Debug

extension DataWrapper {
    static let empty = DataWrapper(code: 0, status: "", copyright: "", data: PageInfo.empty)

    static let withNilData = DataWrapper(code: 0, status: "", copyright: "", data: nil)
}
