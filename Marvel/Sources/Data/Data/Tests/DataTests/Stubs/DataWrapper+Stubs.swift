//
//  DataWrapper+Stubs.swift
//  MarvelTests
//
//  Created by Diego Rogel on 19/1/22.
//

@testable import Data
import Foundation

extension DataWrapper {
    static var empty: DataWrapper<ContentType> {
        DataWrapper(code: 0, status: "", copyright: "", data: PageData<ContentType>.empty)
    }

    static var withNilData: DataWrapper<ContentType> {
        DataWrapper<ContentType>(code: 0, status: "", copyright: "", data: nil)
    }
}
