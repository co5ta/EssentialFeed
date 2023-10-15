//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 15/04/2023.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL)
}

func uniqueImageFeed() -> (model: [FeedImage], local: [LocalFeedImage]) {
    let model = [uniqueImage(), uniqueImage()]
    let local = model.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    return (model, local)
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }

    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
}
