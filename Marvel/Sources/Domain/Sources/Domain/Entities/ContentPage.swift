//
//  ContentPage.swift
//  Marvel
//
//  Created by Diego Rogel on 13/2/22.
//

import Foundation

public protocol Page {
    var offset: Int { get }
    var limit: Int { get }
    var total: Int { get }
}

public struct PageInfo: Page, Equatable {
    public let offset: Int
    public let limit: Int
    public let total: Int

    public init(offset: Int, limit: Int, total: Int) {
        self.offset = offset
        self.limit = limit
        self.total = total
    }
}

public struct ContentPage<Content: Equatable>: Page, Equatable {
    public let offset: Int
    public let limit: Int
    public let total: Int
    public let contents: [Content]

    public init(offset: Int, limit: Int, total: Int, contents: [Content]) {
        self.offset = offset
        self.limit = limit
        self.total = total
        self.contents = contents
    }
}
