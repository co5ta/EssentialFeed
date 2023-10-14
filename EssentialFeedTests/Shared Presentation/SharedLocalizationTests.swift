//
//  SharedLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 14/10/2023.
//

import XCTest
import EssentialFeed

class SharedLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)

        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }

    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }

}
