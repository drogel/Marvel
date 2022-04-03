//
//  UIImageView+URLImage.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation
import UIKit

enum URLImageError: Error {
    case loadingFailed
}

protocol URLImage {
    func loadImage(from url: URL?)
    func clear()
}

class FetchImageView: UIImageView, URLImage {
    private var imageTask: Task<Void, Never>?

    func loadImage(from url: URL?) {
        imageTask = Task { await loadImage(from: url) }
    }

    func clear() {
        image = nil
        imageTask?.cancel()
    }
}

private extension UIImageView {
    func loadImage(from url: URL?) async {
        guard let urlRequest = buildURLRequest(from: url) else { return }
        if let image = retrieveCachedImageIfAny(for: urlRequest) {
            setImage(image)
        } else {
            await requestNetworkImage(urlRequest)
        }
    }

    func buildURLRequest(from url: URL?) -> URLRequest? {
        guard let url = url else { return nil }
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
    }

    func retrieveCachedImageIfAny(for urlRequest: URLRequest) -> UIImage? {
        guard let cachedData = URLCache.shared.cachedResponse(for: urlRequest)?.data else { return nil }
        return UIImage(data: cachedData)
    }

    func requestNetworkImage(_ urlRequest: URLRequest) async {
        guard let requestResult = try? await URLSession.shared.data(for: urlRequest, delegate: nil) else { return }
        let data = requestResult.0
        let response = requestResult.1
        cacheResponse(from: urlRequest, data: data, response: response)
        handleRequestResult(data: data)
    }

    func handleRequestResult(data: Data) {
        guard let image = UIImage(data: data) else { return }
        setImage(image)
    }

    func setImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.image = image
        }
    }

    func cacheResponse(from urlRequest: URLRequest, data: Data, response: URLResponse) {
        let cachedData = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedData, for: urlRequest)
    }
}
