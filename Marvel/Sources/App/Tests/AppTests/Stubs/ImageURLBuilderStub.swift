//
//  ImageURLBuilderStub.swift
//
//
//  Created by Diego Rogel on 28/9/22.
//

import Domain
import Foundation

class ImageURLBuilderStub: ImageURLBuilder {
    let urlStub = URL(string: "https://example.com")!

    func buildURL(from _: Image, variant _: ImageVariant) -> URL? {
        urlStub
    }

    func buildURL(from _: Image) -> URL? {
        urlStub
    }
}
