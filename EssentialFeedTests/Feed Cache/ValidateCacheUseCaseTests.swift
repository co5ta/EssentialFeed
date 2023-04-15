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

    func test_validateCache_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()

        sut.validateCache()
        store.completeRetrieval(with: anyNSError)

        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCacheFeed])
    }

    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()

        sut.validateCache()
        store.completeRetrievalWithEmptyCache()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_validateCache_doesNotDeleteLessThanSevenDaysOldCache() {
        let fixedCurrentDate = Date()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        let lessThanSeventDaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)

        sut.validateCache()
        store.completeRetrieval(with: uniqueImageFeed().local, timestamp: lessThanSeventDaysOldTimestamp)

        XCTAssertEqual(store.receivedMessages, [.retrieve])
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

    private func uniqueImageFeed() -> (model: [FeedImage], local: [LocalFeedImage]) {
        let model = [FeedImage(id: UUID(), description: nil, location: nil, url: anyURL)]
        let local = model.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
        return (model: model, local: local)
    }

    private var anyURL: URL {
        URL(string: "http://any-url.com")!
    }

    private var anyNSError: NSError {
        NSError(domain: "", code: 0)
    }
}

private extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }

    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
