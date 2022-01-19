//
//  PageInfo.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

struct PageInfo: Codable, Equatable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    // TODO: Add results field. From the Marvel docs: The list of characters returned by the call.
}
