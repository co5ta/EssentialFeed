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
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "expected no view messages")
    }
}

// MARK: - Helpers

extension FeedPresenterTests {
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(view: view)
        trackForMemoryLeaks(element: view, file: file, line: line)
        trackForMemoryLeaks(element: sut, file: file, line: line)
        return (sut, view)
    }
    private class ViewSpy {
        let messages = [Any]()
    }
}
