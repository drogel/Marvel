//
//  CollectionViewDataSourceMock.swift
//  MarvelTests
//
//  Created by Diego Rogel on 3/2/22.
//

import Foundation
@testable import Marvel_Debug
import UIKit
import XCTest

class CollectionViewDataSourceMock: NSObject, CollectionViewDataSource, UICollectionViewDataSource {
    var updateCallCount = 0
    var setDataSourceCallCount = 0
    var registerSubviewsCallCount = 0
    var numberOfItemsInSectionCallCount = 0
    var cellForItemAtCallCount = 0

    func setDataSource(of _: UICollectionView) {
        setDataSourceCallCount += 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        numberOfItemsInSectionCallCount += 1
        return 0
    }

    func collectionView(_: UICollectionView, cellForItemAt _: IndexPath) -> UICollectionViewCell {
        cellForItemAtCallCount += 1
        return UICollectionViewCell()
    }

    func update<T: Hashable>(with _: [T]) {
        updateCallCount += 1
    }

    func assertUpdate(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(updateCallCount, callCount, line: line)
    }

    func assertSetDataSource(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(setDataSourceCallCount, callCount, line: line)
    }
}
