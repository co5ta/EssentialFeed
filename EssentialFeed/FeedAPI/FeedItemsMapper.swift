//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 09/02/2023.
//

import Foundation

final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == 200,
              let root = try? JSONDecoder().decode(Root.self, from: data)
        else { throw RemoteFeedLoader.Error.invalidData }
        return root.items
    }
}

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
