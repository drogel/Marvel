//
//  DataWrapper.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Foundation

public struct DataWrapper<ContentType: DataObject>: DataObject {
    let code: Int?
    let status: String?
    let copyright: String?
    let data: PageData<ContentType>?
}
