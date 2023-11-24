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

        _ = try? sut.load()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError

        expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }

    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }

    func test_load_deliversCachedImagesOnNonExpiredCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success(feed.model), when: {
            store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimestamp)
        })
    }

    func test_load_deliversNoImagesOnCacheExpiration() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrieval(with: feed.local, timestamp: expirationTimestamp)
        })
    }

    func test_load_deliversNoImagesOnExpiredCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrieval(with: feed.local, timestamp: expiredTimestamp)
        })
    }

    func test_load_hasNoSideEffectOnRetrievalError() {
        let (sut, store) = makeSUT()

        store.completeRetrieval(with: anyNSError)
        _ = try? sut.load()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()

        store.completeRetrievalWithEmptyCache()
        _ = try? sut.load()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnNonExpiredCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimestamp)
        _ = try? sut.load()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnCacheExpiration() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        store.completeRetrieval(with: feed.local, timestamp: expirationTimestamp)
        _ = try? sut.load()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnExpiredCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        store.completeRetrieval(with: feed.local, timestamp: expiredTimestamp)
        _ = try? sut.load()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
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

    private func expect(_ sut: LocalFeedLoader, toCompleteWith expectedResult: Result<[FeedImage], Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        action()

        let receivedResult = Result { try sut.load() }

        switch (receivedResult, expectedResult) {
        case let (.success(receivedFeed), .success(expectedFeed)):
            XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)

        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)

        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
