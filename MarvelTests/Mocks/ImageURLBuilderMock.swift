//
//  ImageURLBuilderMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 5/2/22.
//

import Foundation
@testable import Marvel_Debug

class ImageURLBuilderMock: ImageURLBuilder {
    var buildURLCallCount = 0
    var buildURLVariantCallCount = 0
    var mostRecentImageVariant: ImageVariant?

    func buildURL(from _: Image) -> URL? {
        buildURLCallCount += 1
        return nil
    }

    func buildURL(from _: Image, variant: ImageVariant) -> URL? {
        mostRecentImageVariant = variant
        buildURLVariantCallCount += 1
        return nil
    }
}
