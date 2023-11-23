//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 09/09/2023.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
