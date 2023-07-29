//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 29/07/2023.
//
import Foundation

public struct FeedErrorViewModel {
    public let message: String?

    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }

    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}

public struct FeedLoadingViewModel {
    public let isLoading: Bool
}

public struct FeedViewModel {
    public let feed: [FeedImage]
}

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel )
}

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public final class FeedPresenter {
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    private let feedView: FeedView

    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Error message displayed when we can't load the image feed from the server")
    }

    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the feed view")
    }

    public init(loadingView: FeedLoadingView,
         errorView: FeedErrorView,
         feedView: FeedView) {
        self.loadingView = loadingView
        self.errorView = errorView
        self.feedView = feedView
    }

    public func didStartLoadingFeed() {
        errorView.display(FeedErrorViewModel.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(FeedErrorViewModel.error(message: feedLoadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
