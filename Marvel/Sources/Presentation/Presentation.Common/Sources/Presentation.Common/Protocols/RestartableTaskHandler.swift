//
//  RestartableTaskHandler.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import Foundation

public protocol RestartableTaskHandler: TaskHandler {
    @Sendable func start() async
    func restart()
}
