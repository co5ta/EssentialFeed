//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 04/02/2023.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = LoadFeedResult

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success((data, response)):
                completion(self.map(data: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }

    private func map(data: Data, response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, from: response)
            return .success(items.toModel())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteFeedItem {
    func toModel() -> [FeedItem] {
        map { FeedItem(id: $0.id, description: $0.description, location: $0.location, imageURL: $0.image)}
    }
}
