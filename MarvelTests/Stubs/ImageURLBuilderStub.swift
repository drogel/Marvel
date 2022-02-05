//
//  ImageURLBuilderStub.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation
@testable import Marvel_Debug

class ImageURLBuilderStub: ImageURLBuilder {
    func buildURL(from imageData: ImageData) -> URL? {
        URL(string: "https://example.com")!
    }
}
