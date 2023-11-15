//
//  FeedEndPoint.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 15/11/2023.
//

import Foundation

public enum FeedEndPoint {
    case get

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appending(path: "/v1/feed")
        }
    }
}
