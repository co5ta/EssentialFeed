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
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v1/feed"
            components.queryItems = [
                URLQueryItem(name: "limit", value: "10")
            ]
            return components.url!
        }
    }
}
