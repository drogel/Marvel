//
//  OffsetPagerPartialMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 8/2/22.
//

import Domain
import Foundation

public class OffsetPagerPartialMock: Pager {
    private let pager: Pager
    public var isAtEndOfCurrentPageCallCount = 0
    public var isThereMoreContentCallCount = 0
    public var updateCallCount = 0
    public var isAtEndOfCurrentPageMoreContentCallCount = 0

    public init() {
        pager = PagerFactory.create()
    }

    public func isAtEndOfCurrentPage(_ index: Int) -> Bool {
        isAtEndOfCurrentPageCallCount += 1
        return pager.isAtEndOfCurrentPage(index)
    }

    public func isThereMoreContent(at index: Int) -> Bool {
        isThereMoreContentCallCount += 1
        return pager.isThereMoreContent(at: index)
    }

    public func update(currentPage: Page) {
        updateCallCount += 1
        pager.update(currentPage: currentPage)
    }

    public func isAtEndOfCurrentPageWithMoreContent(_ index: Int) -> Bool {
        isAtEndOfCurrentPageMoreContentCallCount += 1
        return pager.isAtEndOfCurrentPageWithMoreContent(index)
    }
}
