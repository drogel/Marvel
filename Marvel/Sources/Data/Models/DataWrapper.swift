//
//  DataWrapper.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import Foundation

struct DataWrapper: Codable, Equatable {
    let code: Int?
    let status: String?
    let copyright: String?
    // TODO: Add data field. From the Marvel docs: data (CharacterDataContainer, optional) - The results returned by the call.
}
