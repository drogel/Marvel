//
//  PagerStub.swift
//  MarvelTests
//
//  Created by Diego Rogel on 8/2/22.
//

@testable import App
import Domain
import Foundation

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
