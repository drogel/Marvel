//
//  PagerStub.swift
//  MarvelTests
//
//  Created by Diego Rogel on 8/2/22.
//

import Foundation
@testable import Marvel_Debug

class PagerStub: Pager {
    func isAtEndOfCurrentPageWithMoreContent(_: Int) -> Bool {
        true
    }

    func isThereMoreContent(at _: Int) -> Bool {
        true
    }

    func isAtEndOfCurrentPage(_: Int) -> Bool {
        true
    }

    func update(currentPage _: Page) {}
}
