//
//  Coordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
    func coordinatorDidFinish(_ coordinator: Coordinator)
}

protocol Coordinator: CoordinatorDelegate {
    var delegate: CoordinatorDelegate? { get }
    var children: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func disposeChild(_ child: Coordinator?) {
        for (index, coordinator) in children.enumerated() {
            guard coordinator === child else { continue }
            children.remove(at: index)
        }
    }

    func coordinatorDidFinish(_ coordinator: Coordinator) {
        disposeChild(coordinator)
    }
}
