//
//  CollectionViewDataSourceFactoryMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 6/3/22.
//

@testable import Marvel_Debug
import UIKit
import XCTest

class CollectionViewDataSourceFactoryMock: CollectionViewDataSourceFactory {
    var createCallCount = 0
    let dataSourceMock = CollectionViewDataSourceMock()

    func create(collectionView _: UICollectionView) -> CollectionViewDataSource {
        createCallCount += 1
        return dataSourceMock
    }

    func assertCreate(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(createCallCount, callCount, line: line)
    }
}
