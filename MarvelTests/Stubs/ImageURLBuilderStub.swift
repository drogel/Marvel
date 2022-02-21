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

    func buildURL(from _: Image, variant _: ImageVariant) -> URL? {
        urlStub
    }

    func buildURL(from _: Image) -> URL? {
        urlStub
    }
}
