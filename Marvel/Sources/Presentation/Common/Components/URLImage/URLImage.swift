//
//  URLImage.swift
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
    // TODO: Make URL Image loading cancellable too
    func loadImage(from url: URL?, completion: URLImageCompletion?)
}
