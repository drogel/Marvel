//
//  CoordinatorTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 1/2/22.
//

@testable import Marvel_Debug
import XCTest

class CoordinatorTests: XCTestCase {
    private var sut: CoordinatorMock!
    private var childCoordinator: Coordinator!

    override func setUp() {
        super.setUp()
        childCoordinator = CoordinatorMock()
        sut = CoordinatorMock(children: [childCoordinator])
    }

    override func tearDown() {
        sut = nil
        childCoordinator = nil
        super.tearDown()
    }

    func test_conformsToCoordinatorDelegate() {
        XCTAssertTrue((sut as AnyObject) is CoordinatorDelegate)
    }

    func test_givenChildren_whenDisposingChild_childIsNoLongerInChildrenArray() {
        XCTAssertFalse(sut.children.isEmpty)
        sut.disposeChild(childCoordinator)
        XCTAssertTrue(sut.children.isEmpty)
    }

    func test_givenChildren_whenDidFinish_childIsNoLongerInChildrenArray() {
        XCTAssertFalse(sut.children.isEmpty)
        sut.coordinatorDidFinish(childCoordinator)
        XCTAssertTrue(sut.children.isEmpty)
    }
}

private class CoordinatorMock: Coordinator {
    weak var delegate: CoordinatorDelegate?

    var children: [Coordinator]

    init(children: [Coordinator] = []) {
        self.children = children
    }

    func start() {}
}
