//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 02/02/2023.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    func load(completion: @escaping (Result) -> Void)
}
