//
//  OffsetPagerPartialMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 8/2/22.
//

import Foundation
@testable import Marvel_Debug

class OffsetPagerPartialMock: OffsetPager {
    var isAtEndOfCurrentPageCallCount = 0
    var isThereMoreContentCallCount = 0
    var updateCallCount = 0
    var isAtEndOfCurrentPageMoreContentCallCount = 0

    override func isAtEndOfCurrentPage(_ index: Int) -> Bool {
        isAtEndOfCurrentPageCallCount += 1
        return super.isAtEndOfCurrentPage(index)
    }

    override func isThereMoreContent(at index: Int) -> Bool {
        isThereMoreContentCallCount += 1
        return super.isThereMoreContent(at: index)
    }

    override func update(currentPage: Page) {
        updateCallCount += 1
        super.update(currentPage: currentPage)
    }

    override func isAtEndOfCurrentPageWithMoreContent(_ index: Int) -> Bool {
        isAtEndOfCurrentPageMoreContentCallCount += 1
        return super.isAtEndOfCurrentPageWithMoreContent(index)
    }
}
