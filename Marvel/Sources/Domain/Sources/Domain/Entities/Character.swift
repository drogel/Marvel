//
//  Character.swift
//  Marvel
//
//  Created by Diego Rogel on 13/2/22.
//

import Foundation

public struct Character: Equatable {
    public let identifier: Int
    public let name: String
    public let description: String
    public let image: Image

    public init(identifier: Int, name: String, description: String, image: Image) {
        self.identifier = identifier
        self.name = name
        self.description = description
        self.image = image
    }
}
