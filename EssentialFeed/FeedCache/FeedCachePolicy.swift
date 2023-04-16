//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 16/04/2023.
//

import Foundation

enum FeedCachePolicy {
    static private let calendar = Calendar(identifier: .gregorian)

    static private var maxCacheAgeInDays: Int {
        return 7
    }

    static func validate(_ timestamp: Date, against currentDate: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp)
        else { return false } 
        return currentDate < maxCacheAge
    }
}
