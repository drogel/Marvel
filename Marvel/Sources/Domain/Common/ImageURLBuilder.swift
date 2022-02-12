//
//  ImageURLBuilder.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation

enum ImageVariant: String {
    case fullSize = ""
    case detail
    case portraitSmall = "portrait_small"
    case portraitMedium = "portrait_xlarge"
    case portraitLarge = "portrait_uncanny"
    case standardSmall = "standard_small"
    case standardMedium = "standard_large"
    case standardLarge = "standard_amazing"
    case landscapeSmall = "landscape_small"
    case landscapeMedium = "landscape_large"
    case landscapeLarge = "landscape_incredible"
}

protocol ImageURLBuilder {
    func buildURL(from imageData: ImageData, variant: ImageVariant) -> URL?
    func buildURL(from imageData: ImageData) -> URL?
}

class ImageDataURLBuilder: ImageURLBuilder {
    func buildURL(from imageData: ImageData, variant: ImageVariant) -> URL? {
        guard let insecureURL = buildInsecureURL(from: imageData, variant: variant) else { return nil }
        return buildSecureURL(from: insecureURL)
    }

    func buildURL(from imageData: ImageData) -> URL? {
        buildURL(from: imageData, variant: .fullSize)
    }
}

private extension ImageDataURLBuilder {
    func buildInsecureURL(from imageData: ImageData, variant: ImageVariant) -> URL? {
        guard let path = imageData.path, let imageExtension = imageData.imageExtension else { return nil }
        let fullURL = path + variantPath(for: variant) + "." + imageExtension
        return URL(string: fullURL)
    }

    func buildSecureURL(from insecureURL: URL) -> URL? {
        var components = URLComponents(url: insecureURL, resolvingAgainstBaseURL: false)
        components?.scheme = "https"
        return components?.url
    }

    func variantPath(for variant: ImageVariant) -> String {
        let variantDescriptor = variant.rawValue
        guard !variantDescriptor.isEmpty else { return variantDescriptor }
        return "/" + variantDescriptor
    }
}
