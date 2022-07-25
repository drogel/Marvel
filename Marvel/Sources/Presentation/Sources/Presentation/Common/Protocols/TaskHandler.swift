//
//  CancellableHandler.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import Foundation

protocol TaskHandler {
    var tasks: Set<Task<Void, Never>> { get set }
    func cancelTasks()
}

extension TaskHandler {
    func cancelTasks() {
        tasks.forEach { $0.cancel() }
    }
}
