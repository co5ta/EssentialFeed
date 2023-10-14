//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 29/07/2023.
//
import Foundation

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public final class FeedPresenter {
    private let loadingView: ResourceLoadingView
    private let errorView: FeedErrorView
    private let feedView: FeedView

    private var feedLoadError: String {
        return NSLocalizedString("GENERIC_CONNECTION_ERROR", tableName: "Shared", bundle: Bundle(for: FeedPresenter.self), comment: "Error message displayed when we can't load the image feed from the server")
    }

    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the feed view")
    }

    public init(loadingView: ResourceLoadingView,
         errorView: FeedErrorView,
         feedView: FeedView) {
        self.loadingView = loadingView
        self.errorView = errorView
        self.feedView = feedView
    }

    public func didStartLoadingFeed() {
        errorView.display(FeedErrorViewModel.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }

    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }

    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(FeedErrorViewModel.error(message: feedLoadError))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
}
