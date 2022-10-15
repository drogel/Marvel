//
//  CharacterDetailFactoriesTests.swift
//
//
//  Created by Diego Rogel on 10/7/22.
//

import Domain
import DomainTestUtils
@testable import Presentation_CharacterDetail
import XCTest

class CharacterDetailFactoriesTests: XCTestCase {
    func test_givenAViewControllerFactory_whenCreating_thenReturnsExpectedViewController() {
        let actualViewController = CharacterDetailViewControllerFactory.create(with: CharacterDetailContainerStub())
        XCTAssertTrue(actualViewController is CharacterDetailViewController)
    }
}

private class CharacterDetailContainerStub: CharacterDetailContainer {
    var characterID: Int {
        0
    }

    var fetchCharacterDetailUseCase: FetchCharacterDetailUseCase {
        FetchCharacterDetailUseCaseMock()
    }

    var fetchComicsUseCase: FetchComicsUseCase {
        FetchComicsUseCaseMock()
    }

    var imageURLBuilder: ImageURLBuilder {
        ImageURLBuilderMock()
    }

    var pager: Pager {
        OffsetPagerPartialMock()
    }
}
