//
//  FeedEndPointTests.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 15/11/2023.
//

import XCTest
import EssentialFeed

final class FeedEndPointTests: XCTestCase {

    func test_feed_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!

        let received = FeedEndPoint.get().url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/v1/feed")!

        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/feed", "path")
        XCTAssertEqual(received.query, "limit=10", "query")
    }

    func test_feed_endpointURLAfterGivenImage() {
        let image = uniqueImage()
        let baseURL = URL(string: "http://base-url.com")!

        let received = FeedEndPoint.get(after: image).url(baseURL: baseURL)

        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/feed", "path")
        XCTAssertEqual(received.query?.contains("limit=10"), true, "limit query param")
        XCTAssertEqual(received.query?.contains("after_id=\(image.id)"), true, "after_id query param")

    }

}
