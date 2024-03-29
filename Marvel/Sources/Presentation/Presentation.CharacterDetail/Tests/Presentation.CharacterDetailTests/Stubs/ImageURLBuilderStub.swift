//
//  ImageURLBuilderStub.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Domain
import Foundation
@testable import Presentation_CharacterDetail

class ImageURLBuilderStub: ImageURLBuilder {
    let urlStub = URL(string: "https://example.com")!

    func buildURL(from _: Image, variant _: ImageVariant) -> URL? {
        urlStub
    }

    func buildURL(from _: Image) -> URL? {
        urlStub
    }
}
