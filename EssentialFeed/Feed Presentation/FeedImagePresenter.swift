//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 06/08/2023.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location)
    }
}
