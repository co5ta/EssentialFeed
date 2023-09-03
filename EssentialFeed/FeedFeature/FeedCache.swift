//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 03/09/2023.
//

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
