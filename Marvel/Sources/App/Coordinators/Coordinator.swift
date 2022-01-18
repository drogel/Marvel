//
//  Coordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

protocol Coordinator {
    var children: [Coordinator] { get }
    var navigationController: UINavigationController { get }

    func start()
}
