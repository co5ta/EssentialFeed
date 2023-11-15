//
//  ImageCommentsEndPoint.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 15/11/2023.
//

import Foundation

public enum ImageCommentsEndPoint {
    case get(UUID)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appending(path: "/v1/image/\(id)/comments")
        }
    }
}
