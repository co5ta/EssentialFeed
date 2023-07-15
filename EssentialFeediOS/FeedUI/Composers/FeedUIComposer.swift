//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Costa Monzili on 21/06/2023.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
    private init() {}

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))

        let feedController = FeedViewController.makeWith(delegate: presentationAdapter, title: FeedPresenter.title)

        presentationAdapter.presenter = FeedPresenter(
            loadingView: WeakRefVirtualProxy(feedController),
            feedView: FeedViewAdapter(controller: feedController, loader: MainQueueDispatchDecorator(decoratee: imageLoader)))
        return feedController
    }
}

private extension FeedViewController {
    static func makeWith(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let storyboard = UIStoryboard(name: "Feed", bundle: Bundle(for: FeedViewController.self))
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = title
        return feedController
    }
}
