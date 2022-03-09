//
//  CharactersCoordinatorTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 1/2/22.
//

@testable import Marvel_Debug
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
        sut.model(CharactersPresentationModelStub(), didSelectCharacterWith: 0)
        XCTAssertTrue(navigationController.mostRecentPresentedViewController is CharacterDetailViewController)
    }
}

private class CharactersDependenciesStub: CharactersDependencies {
    var networkService: NetworkService {
        NetworkServiceSuccessfulStub()
    }

    var scheme: AppScheme {
        .debug
    }
}

private class CharactersPresentationModelStub: CharactersPresentationModelProtocol {
    var numberOfItems: Int {
        0
    }

    var cellModels: [CharacterCellModel] {
        []
    }

    func willDisplayCell(at _: IndexPath) {}

    func select(at _: IndexPath) {}

    func cellModel(at _: IndexPath) -> CharacterCellModel? {
        nil
    }

    func start() {}

    func dispose() {}
}

private extension CharactersCoordinatorTests {
    func assertCoordinatorDelegateDidFinish(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(delegateMock.didFinishCallCount, callCount, line: line)
    }
}
