//
//  CharactersCoordinatorTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 1/2/22.
//

@testable import App
import Combine
import Domain
import Presentation
import XCTest

class CharactersCoordinatorTests: XCTestCase {
    private var sut: CharactersCoordinator!
    private var navigationController: UINavigationControllerMock!
    private var delegateMock: CoordinatorDelegateMock!

    override func setUp() {
        super.setUp()
        navigationController = UINavigationControllerMock()
        delegateMock = CoordinatorDelegateMock()
        CharactersContainer.charactersContainer.register { CharactersDependenciesStub() }
        CharactersContainer.Registrations.push()
        sut = CharactersCoordinator(navigationController: navigationController)
        sut.delegate = delegateMock
    }

    override func tearDown() {
        sut = nil
        CharactersContainer.Registrations.pop()
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
    let fetchCharactersUseCase: FetchCharactersUseCase = FetchCharactersUseCaseStub()
    let imageURLBuilder: ImageURLBuilder = ImageURLBuilderStub()
    let pager: Pager = PagerStub()
}

private class FetchCharactersUseCaseStub: FetchCharactersUseCase {
    func fetch(query _: FetchCharactersQuery) async throws -> ContentPage<Character> {
        .empty
    }
}

private extension CharactersCoordinatorTests {
    func assertCoordinatorDelegateDidFinish(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(delegateMock.didFinishCallCount, callCount, line: line)
    }
}
