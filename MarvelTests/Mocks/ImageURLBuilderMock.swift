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

    func buildURL(from _: ImageData) -> URL? {
        buildURLCallCount += 1
        return nil
    }

    func buildURL(from _: ImageData, variant _: ImageVariantDescriptor) -> URL? {
        buildURLVariantCallCount += 1
        return nil
    }
}
