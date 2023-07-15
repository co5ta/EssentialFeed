//
//  FeedUIIntegrationTests+Assertions.swift
//  EssentialFeediOSTests
//
//  Created by Costa Monzili on 21/06/2023.
//

import XCTest
import EssentialFeed
import EssentialFeediOS

extension FeedUIIntegrationTests {
    func assertThat(_ sut: FeedViewController, hasViewConfiguredFor image: FeedImage, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.feedImageView(at: index)

        guard let cell = view as? FeedImageCell else {
            return XCTFail("expected \(FeedImageCell.self) instance got \(String(describing: view)) instead", file: file, line: line)
        }
        let shouldLocationBeVisible = (image.location != nil)
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "expected isShowingLocation to be \(shouldLocationBeVisible) for image view at index \(index)", file: file, line: line)
        XCTAssertEqual(cell.locationText, image.location, "expected location text to be \(String(describing: image.location)) for image view at index \(index)", file: file, line: line)
        XCTAssertEqual(cell.descriptionText, image.description, "expecter description test to be \(String(describing: image.description)) for image view at index \(index)", file: file, line: line)
    }

    func assertThat(_ sut: FeedViewController, isRendering feed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedFeedImageViews() == feed.count else {
            return XCTFail("expected \(feed.count) images, got \(sut.numberOfRenderedFeedImageViews()) instead", file: file, line: line)
        }
        feed.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index)
        }
    }
}
