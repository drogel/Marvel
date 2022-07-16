//
//  Coordinator.swift
//  Marvel
//
//  Created by Diego Rogel on 18/1/22.
//

public protocol Startable {
    func start()
}

protocol CoordinatorDelegate: AnyObject {
    func coordinatorDidFinish(_ coordinator: Coordinator)
}

protocol Coordinator: Startable, CoordinatorDelegate {
    var delegate: CoordinatorDelegate? { get }
    var children: [Coordinator] { get set }
}

extension Coordinator {
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        disposeChild(coordinator)
    }

    func disposeChild(_ child: Coordinator?) {
        for (index, coordinator) in children.enumerated() {
            guard coordinator === child else { continue }
            children.remove(at: index)
        }
    }
}
