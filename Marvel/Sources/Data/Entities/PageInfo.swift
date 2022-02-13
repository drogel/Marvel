//
//  PageInfo.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

// TODO: Remove Pageable from here when migration to domain entities is finished.
// We will only need play PafeInfos for parsing then.
protocol Pageable {
    var offset: Int? { get }
    var limit: Int? { get }
    var total: Int? { get }
    var count: Int? { get }
}

struct PageInfo<ContentType: DataObject>: Pageable, DataObject {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [ContentType]?
}
