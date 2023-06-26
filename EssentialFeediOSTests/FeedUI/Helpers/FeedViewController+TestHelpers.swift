//
//  FeedViewController+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Costa Monzili on 20/06/2023.
//

import UIKit
import EssentialFeediOS

extension FeedViewController {
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }

    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        return feedImageView(at: index) as? FeedImageCell
    }

    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)

        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImageSectionIndex)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        return view
    }

    func simulateFeedImageViewNearVisible(at row: Int) {
        let dataSource = tableView.prefetchDataSource
        let indexPath = IndexPath(row: row, section: feedImageSectionIndex)
        dataSource?.tableView(tableView, prefetchRowsAt: [indexPath])
    }

    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewNearVisible(at: row)
        let dataSource = tableView.prefetchDataSource
        let indexPath = IndexPath(row: row, section: feedImageSectionIndex)
        dataSource?.tableView?(tableView, cancelPrefetchingForRowsAt: [indexPath])
    }

    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }

    func numberOfRenderedFeedImageViews() -> Int {
        tableView(tableView, numberOfRowsInSection: feedImageSectionIndex)
    }

    func feedImageView(at row: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource
        let indexPath = IndexPath(row: row, section: feedImageSectionIndex)
        return dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }

    private var feedImageSectionIndex: Int {
        return 0
    }
}
