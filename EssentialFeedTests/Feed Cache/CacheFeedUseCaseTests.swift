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

    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        sut.save(uniqueImageFeed().model) { _ in }

        XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed])
    }

    func test_save_doesNotRequestsCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError

        sut.save(uniqueImageFeed().model) { _ in }
        store.completeDeletion(with: deletionError)

        XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed])
    }

    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let (sut, store) = makeSUT() { timestamp }
        let feed = uniqueImageFeed()
        sut.save(feed.model) { _ in }
        store.completeDeletionSuccessfully()

        XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed, .insert(feed.local, timestamp)])
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

    func test_save_doesNotDeliverDeletionErrorAfterSUTHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)

        var receivedResults = [LocalFeedLoader.SaveResult]()
        sut?.save(uniqueImageFeed().model, completion: { receivedResults.append($0) })

        sut = nil
        store.completeDeletion(with: anyNSError)
        XCTAssertTrue(receivedResults.isEmpty)
    }

    func test_save_doesNotDeliverInsertionErrorAfterSUTHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)

        var receivedResults = [LocalFeedLoader.SaveResult]()
        sut?.save(uniqueImageFeed().model, completion: { receivedResults.append($0) })

        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError)
        XCTAssertTrue(receivedResults.isEmpty)
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
        let exp = expectation(description: "wait for  completion")

        var receivedError: Error?
        sut.save(uniqueImageFeed().model) { result in
            if case let .failure(error) = result {
                receivedError = error
            }
            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
}
