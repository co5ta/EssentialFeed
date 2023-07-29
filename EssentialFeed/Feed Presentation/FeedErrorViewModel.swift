//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 29/07/2023.
//

public struct FeedErrorViewModel {
    public let message: String?

    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }

    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
