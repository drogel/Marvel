//
//  ImageMapper.swift
//  Marvel
//
//  Created by Diego Rogel on 13/2/22.
//

import Foundation
import Domain

protocol ImageMapper {
    func mapToImage(_ data: ImageData?) -> Image?
}

class ImageDataMapper: ImageMapper {
    func mapToImage(_ data: ImageData?) -> Image? {
        guard let data = data, let path = data.path, let imageExtension = data.imageExtension else { return nil }
        return Image(path: path, imageExtension: imageExtension)
    }
}
