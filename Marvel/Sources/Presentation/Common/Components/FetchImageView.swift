//
//  UIImageView+URLImage.swift
//  Marvel
//
//  Created by Diego Rogel on 22/1/22.
//

import Foundation
import UIKit

typealias URLImageCompletion = (Result<UIImage, Error>) -> Void

enum URLImageError: Error {
    case loadingFailed
}

protocol URLImage {
    func loadImage(from url: URL?, completion: URLImageCompletion?)
    func clear()
}

class FetchImageView: UIImageView, URLImage {
    // TODO: Move this to async await
    func loadImage(from url: URL?, completion: URLImageCompletion? = nil) {
        guard let urlRequest = buildURLRequest(from: url) else { return }
        if let image = retrieveCachedImageIfAny(for: urlRequest) {
            self.image = image
        } else {
            requestNetworkImage(urlRequest, completion: completion)
        }
    }

    func clear() {
        image = nil
    }
}

private extension UIImageView {
    func buildURLRequest(from url: URL?) -> URLRequest? {
        guard let url = url else { return nil }
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
    }

    func retrieveCachedImageIfAny(for urlRequest: URLRequest) -> UIImage? {
        guard let cachedData = URLCache.shared.cachedResponse(for: urlRequest)?.data else { return nil }
        return UIImage(data: cachedData)
    }

    func requestNetworkImage(_ urlRequest: URLRequest, completion: URLImageCompletion?) {
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, _ in
            guard let self = self else { return }
            guard let data = data, let response = response else {
                completion?(.failure(URLImageError.loadingFailed))
                return
            }
            self.cacheResponse(from: urlRequest, data: data, response: response)
            self.handleNetworkImage(response: response, data: data, completion: completion)
        }
        dataTask.resume()
    }

    func handleNetworkImage(response _: URLResponse, data: Data, completion: URLImageCompletion?) {
        DispatchQueue.main.async {
            guard let image = UIImage(data: data) else {
                completion?(.failure(URLImageError.loadingFailed))
                return
            }
            self.image = image
            completion?(.success(image))
        }
    }

    func cacheResponse(from urlRequest: URLRequest, data: Data, response: URLResponse) {
        let cachedData = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedData, for: urlRequest)
    }
}
