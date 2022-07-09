//
//  ImageData.swift
//  Marvel
//
//  Created by Diego Rogel on 19/1/22.
//

import Foundation

public struct ImageData: DataObject {
    let path: String?
    let imageExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }

    init(path: String?, imageExtension: String?) {
        self.path = path
        self.imageExtension = imageExtension
    }
}
