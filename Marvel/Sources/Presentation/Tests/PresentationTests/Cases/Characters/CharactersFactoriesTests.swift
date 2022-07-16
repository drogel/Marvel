//
//  CharactersFactoriesTests.swift
//
//
//  Created by Diego Rogel on 10/7/22.
//

import Domain
import DomainTestUtils
@testable import Presentation
import XCTest

class CharactersFactoriesTests: XCTestCase {
    func test_givenACharactersViewControllerFactory_whenCreating_thenReturnsExpectedViewControllerType() {
        let viewController = CharactersViewControllerFactory.create(
            using: CharactersContainerStub(),
            delegate: CharactersViewModelCoordinatorDelegateStub()
        )
        XCTAssertTrue(viewController is CharactersViewController)
    }
}

private class CharactersContainerStub: CharactersContainer {
    var fetchCharactersUseCase: FetchCharactersUseCase {
        FetchCharactersUseCaseMock()
    }

    var imageURLBuilder: ImageURLBuilder {
        ImageURLBuilderMock()
    }

    var pager: Pager {
        OffsetPagerPartialMock()
    }
}

private class CharactersViewModelCoordinatorDelegateStub: CharactersViewModelCoordinatorDelegate {
    func model(didSelectCharacterWith _: Int) {}
}
