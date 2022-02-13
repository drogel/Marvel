//
//  ContentPage.swift
//  Marvel
//
//  Created by Diego Rogel on 13/2/22.
//

import Foundation

protocol Page {
    var offset: Int { get }
    var limit: Int { get }
    var total: Int { get }
}

struct PageInfo: Page, Equatable {
    let offset: Int
    let limit: Int
    let total: Int
}

struct ContentPage<Content: Equatable>: Page, Equatable {
    let offset: Int
    let limit: Int
    let total: Int
    let contents: [Content]
}
