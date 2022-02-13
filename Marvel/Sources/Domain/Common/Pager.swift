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
    func update(currentPage: Pageable)
}

class OffsetPager: Pager {
    private var currentPage: Pageable?

    func update(currentPage: Pageable) {
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
        return index == offset + limit - 1
    }

    func isAtEndOfCurrentPageWithMoreContent(_ index: Int) -> Bool {
        isAtEndOfCurrentPage(index) && isThereMoreContent(at: index)
    }
}
