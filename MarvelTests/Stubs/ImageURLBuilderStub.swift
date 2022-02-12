//
//  ImageURLBuilderStub.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation
@testable import Marvel_Debug

class ImageURLBuilderStub: ImageURLBuilder {
    let urlStub = URL(string: "https://example.com")!

    func buildURL(from _: ImageData, variant _: ImageVariantDescriptor) -> URL? {
        urlStub
    }

    func buildURL(from _: ImageData) -> URL? {
        urlStub
    }
}
