//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 23/07/2023.
//

import XCTest

final class FeedPresenter {
    init(view: Any) { }
}

final class FeedPresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()

        _ = FeedPresenter(view: view)

        XCTAssertTrue(view.messages.isEmpty, "expected no view messages")
    }
}

// MARK: - Helpers

extension FeedPresenterTests {

    private class ViewSpy {
        let messages = [Any]()
    }
}
