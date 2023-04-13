//
//  ValidateCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 13/04/2023.
//

import XCTest
import EssentialFeed

final class ValidateCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    
}

extension ValidateCacheUseCaseTests {
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (LocalFeedLoader, FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(element: store, file: file, line: line)
        trackForMemoryLeaks(element: sut, file: file, line: line)
        return (sut, store)
    }
}
