//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 09/02/2023.
//

import Foundation

final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [Item]
    }

    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL

        var item: FeedItem {
            FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }

    static func map(_ data: Data, _ response: HTTPURLResponse) -> [FeedItem]? {
        guard response.statusCode == 200,
              let root = try? JSONDecoder().decode(Root.self, from: data)
        else { return nil }
        return root.items.map { $0.item }
    }
}
