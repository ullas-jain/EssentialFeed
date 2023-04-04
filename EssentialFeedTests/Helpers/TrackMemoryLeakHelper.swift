//
//  TrackMemoryLeakHelper.swift
//  EssentialFeedTests
//
//  Created by Jain Ullas on 4/4/23.
//

import XCTest

extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject,
                                     file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential Memory leak", file: file, line: line)
        }
    }
    
}
