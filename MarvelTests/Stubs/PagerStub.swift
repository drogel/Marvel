//
//  PagerStub.swift
//  MarvelTests
//
//  Created by Diego Rogel on 8/2/22.
//

import Foundation
@testable import Marvel_Debug

class PagerStub: Pager {
    func isAtEndOfCurrentPageWithMoreContent(_ offset: Int) -> Bool {
        true
    }

    func isThereMoreContent(at offset: Int) -> Bool {
        true
    }

    func isAtEndOfCurrentPage(_ offset: Int) -> Bool {
        true
    }

    func update(currentPage: Page) { }
}
