//
//  Comic.swift
//  Marvel
//
//  Created by Diego Rogel on 13/2/22.
//

import Foundation

public struct Comic: Equatable {
    public let identifier: Int
    public let title: String
    public let issueNumber: Int
    public let image: Image

    public init(identifier: Int, title: String, issueNumber: Int, image: Image) {
        self.identifier = identifier
        self.title = title
        self.issueNumber = issueNumber
        self.image = image
    }
}
