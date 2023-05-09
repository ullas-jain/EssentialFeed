//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Jain Ullas on 4/1/23.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    
    
    let client: HTTPClient
    let url: URL
    
    public typealias Result = FeedLoader.Result
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        client.get(from: url) { [weak self] httpClientResult in
            guard self != nil else { return }
            switch httpClientResult {
            case let .success(data, response):
                completion(RemoteFeedLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteFeedItem {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, url: $0.image, description: $0.description, location: $0.location) }
    }
}
