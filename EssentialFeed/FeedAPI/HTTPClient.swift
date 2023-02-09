//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 09/02/2023.
//

import Foundation

public typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
