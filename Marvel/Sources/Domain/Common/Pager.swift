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
    func update(currentPage: Page)
}

class OffsetPager: Pager {
    private var currentPage: Page?

    func update(currentPage: Page) {
        self.currentPage = currentPage
    }

    func isThereMoreContent(at offset: Int) -> Bool {
        guard let currentPage = currentPage, let total = currentPage.total else { return false }
        return offset < total
    }

    func isAtEndOfCurrentPage(_ offset: Int) -> Bool {
        guard let currentPage = currentPage, let limit = currentPage.limit else { return false }
        return offset >= limit - 1
    }
}
