//
//  Image.swift
//  Marvel
//
//  Created by Diego Rogel on 13/2/22.
//

import Foundation

public struct Image: Equatable {
    let path: String
    let imageExtension: String

    public init(path: String, imageExtension: String) {
        self.path = path
        self.imageExtension = imageExtension
    }
}
