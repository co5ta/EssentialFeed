//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 15/04/2023.
//

import Foundation

var anyURL: URL {
    URL(string: "http://any-url.com")!
}

var anyNSError: NSError {
    NSError(domain: "", code: 0)
}

var anyData: Data {
    Data("any data".utf8)
}

var emptyData: Data {
    Data()
}

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    let json = ["items": items]
    return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
