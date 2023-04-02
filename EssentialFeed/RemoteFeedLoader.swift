//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Jain Ullas on 4/1/23.
//

import Foundation

public final class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] httpClientResult in
            guard self != nil else { return }
            switch httpClientResult {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
