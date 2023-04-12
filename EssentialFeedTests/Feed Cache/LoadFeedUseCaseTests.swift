//
//  LoadFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 11/04/2023.
//

import XCTest
import EssentialFeed

final class LoadFeedUseCaseTests: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_load() {
        let (sut, store) = makeSUT()

        sut.load() { _ in}

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError

        let exp = expectation(description: "wait for load completion")

        var receivedError: Error?
        sut.load { error in
            receivedError = error
            exp.fulfill()
        }

        store.completeRetrieval(with: retrievalError)
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(receivedError as? NSError, retrievalError)
    }
}

extension LoadFeedUseCaseTests {
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (LocalFeedLoader, FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(element: store, file: file, line: line)
        trackForMemoryLeaks(element: sut, file: file, line: line)
        return (sut, store)
    }

    private var anyNSError: NSError {
        NSError(domain: "", code: 0)
    }
}
