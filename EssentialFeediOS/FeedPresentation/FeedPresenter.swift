//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Costa Monzili on 25/06/2023.
//

import Foundation
import EssentialFeed

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel )
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

final class FeedPresenter {
    private let loadingView: FeedLoadingView
    private let feedView: FeedView

    init(loadingView: FeedLoadingView, feedView: FeedView) {
        self.loadingView = loadingView
        self.feedView = feedView
    }

    static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the feed view")
    }

    func didStartLoadingFeed() {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in self?.didStartLoadingFeed() }
        }
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    func didFinishLoadingFeed(with feed: [FeedImage]) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in self?.didFinishLoadingFeed(with: feed) }
        }
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    func didFinishLoading(with error: Error) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in self?.didFinishLoading(with: error) }
        }
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
