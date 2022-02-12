//
//  ImageURLBuilder.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation

enum ImageVariantDescriptor: String {
    case fullSize = ""
    case detail

    enum Portrait: String {
        case small = "portrait_small"
        case medium = "portrait_xlarge"
        case large = "portrait_uncanny"
    }

    enum Standard: String {
        case small = "standard_small"
        case medium = "standard_large"
        case large = "standard_amazing"
    }

    enum Landscape: String {
        case small = "landscape_small"
        case medium = "landscape_large"
        case large = "landscape_incredible"
    }
}

protocol ImageURLBuilder {
    func buildURL(from imageData: ImageData, variant: ImageVariantDescriptor) -> URL?
    func buildURL(from imageData: ImageData) -> URL?
}

class ImageDataURLBuilder: ImageURLBuilder {
    func buildURL(from _: ImageData, variant _: ImageVariantDescriptor) -> URL? {
        nil
    }

    func buildURL(from imageData: ImageData) -> URL? {
        guard let insecureURL = buildInsecureURL(from: imageData) else { return nil }
        return buildSecureURL(from: insecureURL)
    }
}

private extension ImageDataURLBuilder {
    func buildInsecureURL(from imageData: ImageData) -> URL? {
        guard let path = imageData.path, let imageExtension = imageData.imageExtension else { return nil }
        let fullURL = path + "." + imageExtension
        return URL(string: fullURL)
    }

    func buildSecureURL(from insecureURL: URL) -> URL? {
        var components = URLComponents(url: insecureURL, resolvingAgainstBaseURL: false)
        components?.scheme = "https"
        return components?.url
    }
}
