//
//  PageData.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

protocol Pageable {
    var offset: Int? { get }
    var limit: Int? { get }
    var total: Int? { get }
    var count: Int? { get }
}

struct PageData<ContentType: DataObject>: Pageable, DataObject {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [ContentType]?
}
