//
//  TaskHandlingViewController.swift
//  Marvel
//
//  Created by Diego Rogel on 10/7/22.
//

import UIKit

class TaskHandlingViewController: UIViewController {
    var tasks: Set<Task<Void, Never>> = .init()

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelTasks()
    }
}

private extension TaskHandlingViewController {
    func cancelTasks() {
        tasks.forEach { $0.cancel() }
    }
}
