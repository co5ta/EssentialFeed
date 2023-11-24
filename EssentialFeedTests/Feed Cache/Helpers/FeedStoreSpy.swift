//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 12/04/2023.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }

    private(set) var receivedMessages: [ReceivedMessage] = []

    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedFeed?, Error>?

    func deleteCachedFeed() throws {
        receivedMessages.append(.deleteCachedFeed)
        try deletionResult?.get()
    }

    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionResult = .failure(error)
    }

    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionResult = .success(())
    }

    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        receivedMessages.append(.insert(feed, timestamp))
        try insertionResult?.get()
    }

    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }

    func completeCacheInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }

    func retrieve() throws -> CachedFeed? {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get()
    }

    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalResult = .failure(error)
    }

    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalResult = .success(nil)
    }

    func completeRetrieval(with feed: [LocalFeedImage], timestamp: Date, at index: Int = 0) {
        retrievalResult = .success(CachedFeed(feed: feed, timestamp: timestamp))
    }
}
