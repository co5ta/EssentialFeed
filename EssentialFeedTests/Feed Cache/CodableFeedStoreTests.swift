//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 18/04/2023.
//

import XCTest
import EssentialFeed

private final class CodableFeedStore {
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.empty)
    }
}

class CodableFeedStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableFeedStore()

        let exp = expectation(description: "wait for cache retrieval")

        sut.retrieve { result in
            switch result {
            case .empty:
                break
            default:
                XCTFail("empty result expected, got \(result) instead")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func test_retrieve_hasNoSideEffectOnEmptyCache() {
        let sut = CodableFeedStore()

        let exp = expectation(description: "wait for cache retrieval")

        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                default:
                    XCTFail("empty result expected twice, got \(firstResult) and \(secondResult) instead")
                }
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1.0)
    }
}
