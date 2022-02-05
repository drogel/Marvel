//
//  CharacterDetailCoordinatorTests.swift
//  MarvelTests
//
//  Created by Diego Rogel on 1/2/22.
//

@testable import Marvel_Debug
import XCTest

class CharacterDetailCoordinatorTests: XCTestCase {
    private var sut: CharacterDetailCoordinator!
    private var navigationController: UINavigationControllerMock!
    private var delegateMock: CoordinatorDelegateMock!
    private var container: CharacterDetailContainerStub!

    override func setUp() {
        super.setUp()
        navigationController = UINavigationControllerMock()
        delegateMock = CoordinatorDelegateMock()
        container = CharacterDetailContainerStub()
        sut = CharacterDetailCoordinator(
            navigationController: navigationController,
            container: container
        )
        sut.delegate = delegateMock
    }

    override func tearDown() {
        sut = nil
        navigationController = nil
        delegateMock = nil
        container = nil
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

private class CharacterDetailContainerStub: CharacterDetailContainer {
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
}

private class FetchCharacterDetailUseCaseStub: FetchCharacterDetailUseCase {
    func fetch(
        query _: FetchCharacterDetailQuery,
        completion _: @escaping (FetchCharacterDetailResult) -> Void
    ) -> Cancellable? {
        nil
    }
}

private class FetchComicsUseCaseStub: FetchComicsUseCase {
    func fetch(query _: FetchComicsQuery, completion _: @escaping (FetchComicsResult) -> Void) -> Cancellable? {
        nil
    }
}

private extension CharacterDetailCoordinatorTests {
    func assertCoordinatorDelegateDidFinish(callCount: Int, line: UInt = #line) {
        XCTAssertEqual(delegateMock.didFinishCallCount, callCount, line: line)
    }
}
