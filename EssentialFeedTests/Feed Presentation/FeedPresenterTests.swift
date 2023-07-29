//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 23/07/2023.
//

import XCTest
import EssentialFeed

struct FeedErrorViewModel {
    let message: String?

    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
}

struct FeedLoadingViewModel {
    let isLoading: Bool
}

struct FeedViewModel {
    let feed: [FeedImage]
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel )
}

protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

final class FeedPresenter {
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    private let feedView: FeedView

    init(loadingView: FeedLoadingView,
         errorView: FeedErrorView,
         feedView: FeedView) {
        self.loadingView = loadingView
        self.errorView = errorView
        self.feedView = feedView
    }

    func didStartLoadingFeed() {
        errorView.display(FeedErrorViewModel.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}

final class FeedPresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "expected no view messages")
    }

    func test_didStartLoadingFeed_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()

        sut.didStartLoadingFeed()

        XCTAssertEqual(view.messages, [.display(errorMessage: .none), .display(isLoading: true)])
    }

    func test_didFinishLoadingFeed_displaysFeedAndStopLoading() {
        let (sut, view) = makeSUT()
        let feed = uniqueImageFeed().model

        sut.didFinishLoadingFeed(with: feed)

        XCTAssertEqual(view.messages, [.display(feed: feed), .display(isLoading: false)])
    }
}

// MARK: - Helpers

extension FeedPresenterTests {
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(loadingView: view, errorView: view, feedView: view)
        trackForMemoryLeaks(element: view, file: file, line: line)
        trackForMemoryLeaks(element: sut, file: file, line: line)
        return (sut, view)
    }

    private class ViewSpy: FeedErrorView, FeedLoadingView, FeedView {
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(feed: [FeedImage])
        }

        private(set) var messages = Set<Message>()

        func display(_ viewModel: FeedErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }

        func display(_ viewModel: FeedLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }

        func display(_ viewModel: FeedViewModel) {
            messages.insert(.display(feed: viewModel.feed))
        }
    }
}
