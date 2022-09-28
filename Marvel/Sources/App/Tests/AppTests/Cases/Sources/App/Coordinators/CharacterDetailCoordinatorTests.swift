//
//  CharacterDetailCoordinatorTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 1/2/22.
//

@testable import App
import Domain
import DomainTestUtils
import Presentation
import XCTest

class CharacterDetailCoordinatorTests: XCTestCase {
    private var sut: CharacterDetailCoordinator!
    private var navigationController: UINavigationControllerMock!
    private var delegateMock: CoordinatorDelegateMock!

    override func setUp() {
        super.setUp()
        navigationController = UINavigationControllerMock()
        delegateMock = CoordinatorDelegateMock()
        CharacterDetailContainer.characterDetailContainer.register { _ in CharacterDetailContainerStub() }
        CharacterDetailContainer.Registrations.push()
        sut = CharacterDetailCoordinator(navigationController: navigationController, characterID: 0)
        sut.delegate = delegateMock
    }

    override func tearDown() {
        sut = nil
        navigationController = nil
        delegateMock = nil
        CharacterDetailContainer.Registrations.pop()
        super.tearDown()
    }

    func test_whenStarting_presentsCharacterDetailViewControlller() {
        sut.start()
        XCTAssertTrue(navigationController.mostRecentPresentedViewController is CharacterDetailViewController)
    }

    func test_whenDismissingCharacterDetailViewController_callsCoordinatorDidFinish() {
        assertCoordinatorDelegateDidFinish(callCount: 0)
        _ = sut.animationController(forDismissed: CharacterDetailViewController())
        assertCoordinatorDelegateDidFinish(callCount: 1)
    }

    func test_whenDismissingOtherViewController_doesNotCallCoordinatorDidFinish() {
        assertCoordinatorDelegateDidFinish(callCount: 0)
        _ = sut.animationController(forDismissed: UIViewController())
        assertCoordinatorDelegateDidFinish(callCount: 0)
    }
}

private class CharacterDetailContainerStub: CharacterDetailDependencies {
    var characterID: Int {
        0
    }

    var fetchCharacterDetailUseCase: FetchCharacterDetailUseCase {
        FetchCharacterDetailUseCaseStub()
    }

    var fetchComicsUseCase: FetchComicsUseCase {
        FetchComicsUseCaseStub()
    }

    var imageURLBuilder: ImageURLBuilder {
        ImageURLBuilderStub()
    }

    var pager: Pager {
        PagerStub()
    }
}

private class FetchCharacterDetailUseCaseStub: FetchCharacterDetailUseCase {
    func fetch(query _: FetchCharacterDetailQuery) async throws -> ContentPage<Character> {
        ContentPage<Character>.empty
    }
}

private class FetchComicsUseCaseStub: FetchComicsUseCase {
    func fetch(query _: FetchComicsQuery) async throws -> ContentPage<Comic> {
        ContentPage<Comic>.empty
    }
}

private extension CharacterDetailCoordinatorTests {
    func assertCoordinatorDelegateDidFinish(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(delegateMock.didFinishCallCount, callCount, line: line)
    }
}
