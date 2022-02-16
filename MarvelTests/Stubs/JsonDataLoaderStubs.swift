//
//  JsonDataLoaderStubs.swift
//  MarvelTests
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation
@testable import Marvel_Debug

class JsonDataLoaderEmptyStub: JsonDataLoader {
    func load<T>(fromFileNamed _: String) -> T? {
        nil
    }
}

class JsonDataLoaderStub<D: DataObject>: JsonDataLoader {
    let dataWrapperStub = DataWrapper<D>(
        code: 200,
        status: "",
        copyright: "",
        data: PageData<D>.empty
    )

    func load<T>(fromFileNamed _: String) -> T? {
        dataWrapperStub as? T
    }
}
