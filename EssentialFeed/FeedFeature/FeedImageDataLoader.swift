//
//  FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 20/06/2023.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
