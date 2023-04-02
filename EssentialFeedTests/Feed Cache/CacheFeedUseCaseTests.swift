//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 01/04/2023.
//

import XCTest
import EssentialFeed

class LocalFeedLoader {
    let store: FeedStore
    let currentDate: () -> Date
    init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }

    func save(_ items: [FeedItem]) {
        store.deleteCachedFeed { [unowned self] error in
            if error == nil {
                self.store.insert(items, timestamp: self.currentDate())
            }
        }
    }
}

class FeedStore {
    typealias DeletionCompletion = (Error?) -> Void

    var deleteCachedFeedCallCount = 0
    var insertCallCount = 0
    var insertions = [(items: [FeedItem], timestamp: Date)]()

    private var deletionCompletions = [DeletionCompletion]()

    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deleteCachedFeedCallCount += 1
        deletionCompletions.append(completion)
    }

    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }

    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }

    func insert(_ items: [FeedItem], timestamp: Date) {
        insertCallCount += 1
        insertions.append((items, timestamp))
    }
}

final class CacheFeedUseCaseTests: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }

    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let items: [FeedItem] = [uniqueItem, uniqueItem]
        sut.save(items)

        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }

    func test_save_doesNotRequestsCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let items: [FeedItem] = [uniqueItem, uniqueItem]
        let deletionError = anyNSError

        sut.save(items)
        store.completeDeletion(with: deletionError)

        XCTAssertEqual(store.insertCallCount, 0)
    }

    func test_save_requestsNewCacheInsertionOnSuccessfulDeletion() {
        let (sut, store) = makeSUT()
        let items: [FeedItem] = [uniqueItem, uniqueItem]

        sut.save(items)
        store.completeDeletionSuccessfully()

        XCTAssertEqual(store.insertCallCount, 1)
    }

    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let (sut, store) = makeSUT() { timestamp }
        let items: [FeedItem] = [uniqueItem, uniqueItem]

        sut.save(items)
        store.completeDeletionSuccessfully()

        XCTAssertEqual(store.insertions.count, 1)
        XCTAssertEqual(store.insertions.first?.items, items)
        XCTAssertEqual(store.insertions.first?.timestamp, timestamp)
    }
}

// MARK: - Helpers

extension CacheFeedUseCaseTests {
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (LocalFeedLoader, FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(element: store, file: file, line: line)
        trackForMemoryLeaks(element: sut, file: file, line: line)
        return (sut, store)
    }

    private var uniqueItem: FeedItem {
        FeedItem(id: UUID(), description: nil, location: nil, imageURL: anyURL)
    }

    private var anyURL: URL {
        URL(string: "http://any-url.com")!
    }

    private var anyNSError: NSError {
        NSError(domain: "", code: 0)
    }
}
