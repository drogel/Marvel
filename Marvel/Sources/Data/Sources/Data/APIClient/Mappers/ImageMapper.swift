//
//  ImageMapper.swift
//  Marvel
//
//  Created by Diego Rogel on 13/2/22.
//

import Domain
import Foundation

public protocol ImageMapper {
    func mapToImage(_ data: ImageData?) -> Image?
}

public class ImageDataMapper: ImageMapper {
    public init() {}

    public func mapToImage(_ data: ImageData?) -> Image? {
        guard let data = data, let path = data.path, let imageExtension = data.imageExtension else { return nil }
        return Image(path: path, imageExtension: imageExtension)
    }
}
