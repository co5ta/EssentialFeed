//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 19/02/2023.
//

import Foundation

import XCTest

extension XCTestCase {
     func trackForMemoryLeaks(element: AnyObject, file: StaticString, line: UInt) {
        addTeardownBlock { [weak element] in
            XCTAssertNil(element, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
