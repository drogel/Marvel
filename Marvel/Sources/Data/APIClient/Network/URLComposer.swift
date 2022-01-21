//
//  URLComposer.swift
//  Marvel
//
//  Created by Diego Rogel on 21/1/22.
//

import Foundation

protocol URLComposer {
    func compose(from baseURL: URL, adding requestable: Requestable) -> URL?
}

class URLComponentsBuilder: URLComposer {

    func compose(from baseURL: URL, adding requestable: Requestable) -> URL? {
        let url = buildFullURL(from: baseURL, and: requestable)
        guard var urlComponents = urlComponents(from: url) else { return nil }
        urlComponents.queryItems = buildQueryItems(from: requestable)
        return urlComponents.url
    }
}

private extension URLComponentsBuilder {

    func urlComponents(from url: URL) -> URLComponents? {
        URLComponents(url: url, resolvingAgainstBaseURL: false)
    }

    func buildFullURL(from baseURL: URL, and requestable: Requestable) -> URL {
        baseURL.appendingPathComponent(requestable.path)
    }

    func buildQueryItems(from requestable: Requestable) -> [URLQueryItem] {
        requestable.queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
