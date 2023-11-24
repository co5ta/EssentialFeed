//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 03/09/2023.
//

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
