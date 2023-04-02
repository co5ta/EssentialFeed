//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 01/04/2023.
//

import XCTest
import EssentialFeed

final class CacheFeedUseCaseTests: XCTestCase {

    class FeedStore {
        var deleteCachedFeedCallCount = 0

        func deleteCachedFeed() {
            deleteCachedFeedCallCount += 1
        }
    }

    class LocalFeedLoader {
        let store: FeedStore
        init(store: FeedStore) {
            self.store = store
        }

        func save(_ items: [FeedItem]) {
            store.deleteCachedFeed()
        }
    }

    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()
        _ = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }

    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let items: [FeedItem] = [uniqueItem, uniqueItem]
        sut.save(items)

        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
}

// MARK: - Helpers

extension CacheFeedUseCaseTests {
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (LocalFeedLoader, FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
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
}
