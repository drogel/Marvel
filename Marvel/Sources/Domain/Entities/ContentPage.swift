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

struct ContentPage<Content>: Page {
    let offset: Int
    let limit: Int
    let total: Int
    let contents: [Content]
}
