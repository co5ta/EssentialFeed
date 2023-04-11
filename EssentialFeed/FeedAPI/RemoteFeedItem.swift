//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 11/04/2023.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
