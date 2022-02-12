//
//  Instantiable.swift
//  Marvel
//
//  Created by Diego Rogel on 23/1/22.
//

import Foundation

protocol PresentationModelInstantiable {
    associatedtype PresentationModelProtocol
    static func instantiate(presentationModel: PresentationModelProtocol) -> Self
}
