//
//  Pager.swift
//  Marvel
//
//  Created by Diego Rogel on 8/2/22.
//

import Foundation

protocol Pager {
    func isThereMoreContent(at offset: Int) -> Bool
    func isAtEndOfCurrentPage(_ offset: Int) -> Bool
    func isAtEndOfCurrentPageWithMoreContent(_ offset: Int) -> Bool
    func update(currentPage: Page)
}

class OffsetPager: Pager {
    private var currentPage: Page?

    func update(currentPage: Page) {
        self.currentPage = currentPage
    }

    func isThereMoreContent(at index: Int) -> Bool {
        guard let currentPage = currentPage, let total = currentPage.total else { return false }
        return index < total - 1
    }

    func isAtEndOfCurrentPage(_ index: Int) -> Bool {
        guard let currentPage = currentPage,
              let limit = currentPage.limit,
              let offset = currentPage.offset
        else { return false }
        return index + 1 >= offset + limit
    }

    func isAtEndOfCurrentPageWithMoreContent(_ offset: Int) -> Bool {
        isAtEndOfCurrentPage(offset) && isThereMoreContent(at: offset)
    }
}
