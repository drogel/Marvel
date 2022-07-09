//
//  ComicData.swift
//  Marvel
//
//  Created by Diego Rogel on 4/2/22.
//

import Foundation

public struct ComicData: DataObject {
    let identifier: Int?
    let title: String?
    let issueNumber: Int?
    let thumbnail: ImageData?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title
        case issueNumber
        case thumbnail
    }
}
