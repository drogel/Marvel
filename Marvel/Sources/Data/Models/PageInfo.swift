//
//  PageInfo.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

struct PageInfo<ContentType: DataObject>: DataObject {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [ContentType]?
}
