//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 06/08/2023.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?

    public var hasLocation: Bool {
        return location != nil
    }
}
