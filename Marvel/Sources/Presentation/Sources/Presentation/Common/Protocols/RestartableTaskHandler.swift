//
//  RestartableTaskHandler.swift
//
//
//  Created by Diego Rogel on 23/7/22.
//

import Foundation

protocol RestartableTaskHandler: TaskHandler {
    @Sendable func start() async
    func restart()
}
