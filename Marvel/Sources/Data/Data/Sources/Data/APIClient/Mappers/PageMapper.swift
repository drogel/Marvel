//
//  PageMapper.swift
//  Marvel
//
//  Created by Diego Rogel on 13/2/22.
//

import Domain
import Foundation

protocol PageMapper {
    func mapToPageInfo(_ data: Pageable) -> PageInfo?
}

class PageDataMapper: PageMapper {
    func mapToPageInfo(_ data: Pageable) -> PageInfo? {
        guard let offset = data.offset, let limit = data.limit, let total = data.total else { return nil }
        return PageInfo(offset: offset, limit: limit, total: total)
    }
}
