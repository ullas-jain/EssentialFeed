//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Jain Ullas on 4/1/23.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
