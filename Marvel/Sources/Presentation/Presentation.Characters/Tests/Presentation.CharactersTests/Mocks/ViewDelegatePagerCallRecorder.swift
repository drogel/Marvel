//
//  ViewDelegatePagerCallRecorder.swift
//
//
//  Created by Diego Rogel on 10/7/22.
//

import Domain
import Foundation

class ViewDelegatePagerCallRecorder: Pager {
    enum Method: String, CustomDebugStringConvertible {
        case isAtEndOfCurrentPageWithMoreContent
        case update

        var debugDescription: String {
            rawValue
        }
    }

    var methodsCalled: [Method] = []

    func isThereMoreContent(at _: Int) -> Bool {
        true
    }

    func isAtEndOfCurrentPage(_: Int) -> Bool {
        true
    }

    func isAtEndOfCurrentPageWithMoreContent(_: Int) -> Bool {
        methodsCalled.append(.isAtEndOfCurrentPageWithMoreContent)
        return true
    }

    func update(currentPage _: Page) {
        methodsCalled.append(.update)
    }
}
