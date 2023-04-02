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
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }

    func test_save_requestsCacheDeletion() {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        let items: [FeedItem] = [uniqueItem, uniqueItem ]
        sut.save(items)

        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
}

private extension CacheFeedUseCaseTests {
    private var uniqueItem: FeedItem {
        FeedItem(id: UUID(), description: nil, location: nil, imageURL: anyURL)
    }

    private var anyURL: URL {
        URL(string: "http://any-url.com")!
    }
}
