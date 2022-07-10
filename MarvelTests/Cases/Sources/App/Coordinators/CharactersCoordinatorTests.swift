//
//  CharactersCoordinatorTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 1/2/22.
//

import Combine
@testable import Marvel_Debug
import Presentation
import XCTest

class CharactersCoordinatorTests: XCTestCase {
    private var sut: CharactersCoordinator!
    private var navigationController: UINavigationControllerMock!
    private var delegateMock: CoordinatorDelegateMock!
    private var dependencies: CharactersDependenciesStub!

    override func setUp() {
        super.setUp()
        navigationController = UINavigationControllerMock()
        delegateMock = CoordinatorDelegateMock()
        dependencies = CharactersDependenciesStub()
        sut = CharactersCoordinator(
            navigationController: navigationController,
            dependencies: dependencies
        )
        sut.delegate = delegateMock
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_whenStarting_presentsCharactersViewControlller() {
        sut.start()
        XCTAssertTrue(navigationController.visibleViewController is CharactersViewController)
    }

    func test_whenCharacterSelected_presentsCharacterDetailViewController() {
        sut.model(didSelectCharacterWith: 0)
        XCTAssertTrue(navigationController.mostRecentPresentedViewController is CharacterDetailViewController)
    }
}

private class CharactersDependenciesStub: CharactersDependencies {
    var baseApiURL: URL {
        URL(string: "http://example.com")!
    }

    var scheme: AppScheme {
        .debug
    }
}

private extension CharactersCoordinatorTests {
    func assertCoordinatorDelegateDidFinish(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(delegateMock.didFinishCallCount, callCount, line: line)
    }
}
