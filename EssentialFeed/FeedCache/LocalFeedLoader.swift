//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 10/04/2023.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    private let calendar = Calendar(identifier: .gregorian)

    public typealias SaveResult = Error?
    public typealias LoadResult = LoadFeedResult

    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }

    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                completion(error)
            } else {
                self.cache(feed.toLocal(), with: completion)
            }
        }
    }

    private func cache(_ feed: [LocalFeedImage], with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed, timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }

    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [unowned self] result in
            switch result {
            case let .failure(error):
                self.store.deleteCachedFeed { _ in }
                completion(.failure(error))

            case let .found(feed, timestamp) where self.validate(timestamp) :
                completion(.success(feed.toModel()))

            case .found:
                self.store.deleteCachedFeed { _ in }
                completion(.success([]))

            case .empty:
                completion(.success([]))
            }
        }
    }

    private var maxCacheAgeInDays: Int {
        return 7
    }

    private func validate(_ date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: date)
        else { return false }
        return currentDate() < maxCacheAge
    }
}


private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}

private extension Array where Element == LocalFeedImage {
    func toModel() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}