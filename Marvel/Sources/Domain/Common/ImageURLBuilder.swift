//
//  ImageURLBuilder.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation

protocol ImageURLBuilder {
    func buildURL(from imageData: ImageData) -> URL?
}

class ImageDataURLBuilder: ImageURLBuilder {

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
