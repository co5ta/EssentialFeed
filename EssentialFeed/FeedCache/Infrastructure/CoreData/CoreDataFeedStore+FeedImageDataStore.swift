//
//  CoreDataFeedStore+FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 20/08/2023.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {

    public func insert(_ data: Data, for url: URL) throws {
        try performSync { context in
            Result {
                try ManagedFeedImage.first(with: url, in: context)
                    .map { $0.data = data }
                    .map(context.save)
            }
        }
    }

    public func retrieve(dataForURL url: URL) throws -> Data? {
        try performSync { context in
            Result {
                try ManagedFeedImage.data(with: url, in: context)
            }
        }
    }
}
