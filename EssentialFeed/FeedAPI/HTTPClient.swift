//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 09/02/2023.
//

import Foundation

public typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>

public protocol HTTPClient {
    // The completion handler can be invoked in any thread.
    // clients are responsible to dispatch to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
