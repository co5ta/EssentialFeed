//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 01/04/2023.
//

import XCTest
import EssentialFeed

final class CacheFeedUseCaseTests: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_save_doesNotRequestsCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError

        store.completeDeletion(with: deletionError)
        try? sut.save(uniqueImageFeed().model)

        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
    }

    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let (sut, store) = makeSUT() { timestamp }
        let feed = uniqueImageFeed()

        store.completeDeletionSuccessfully()
        try? sut.save(feed.model)

        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed, .insert(feed.local, timestamp)])
    }

    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError

        expect(sut, toCompleteWithError: deletionError, when: {
            store.completeDeletion(with: deletionError)
        })
    }

    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError

        expect(sut, toCompleteWithError: insertionError, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        })
    }

    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWithError: nil, when: {
            store.completeDeletionSuccessfully()
            store.completeCacheInsertionSuccessfully()
        })
    }
}

// MARK: - Helpers

extension CacheFeedUseCaseTests {
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (LocalFeedLoader, FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(element: store, file: file, line: line)
        trackForMemoryLeaks(element: sut, file: file, line: line)
        return (sut, store)
    }

    private func expect(_ sut: LocalFeedLoader, toCompleteWithError expectedError: NSError?, when action: @escaping () -> Void, file: StaticString = #file, line: UInt = #line) {
        action()

        do {
            try sut.save(uniqueImageFeed().model)
        } catch {
            XCTAssertEqual(error as NSError?, expectedError, file: file, line: line)
        }
    }
}
