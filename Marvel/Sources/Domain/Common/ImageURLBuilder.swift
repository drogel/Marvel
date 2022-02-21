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
    func buildURL(from imageData: Image, variant: ImageVariant) -> URL?
    func buildURL(from imageData: Image) -> URL?
}

class SecureImageURLBuilder: ImageURLBuilder {
    func buildURL(from image: Image, variant: ImageVariant) -> URL? {
        guard let insecureURL = buildInsecureURL(from: image, variant: variant) else { return nil }
        return buildSecureURL(from: insecureURL)
    }

    func buildURL(from image: Image) -> URL? {
        buildURL(from: image, variant: .fullSize)
    }
}

private extension SecureImageURLBuilder {
    func buildInsecureURL(from image: Image, variant: ImageVariant) -> URL? {
        let fullURL = image.path + variantPath(for: variant) + "." + image.imageExtension
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
