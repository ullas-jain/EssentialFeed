//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Jain Ullas on 4/2/23.
//

import Foundation

internal class FeedItemsMapper {
    
    private struct Root: Decodable {
        let items: [Item]
        
        var feed: [FeedItem] {
            return items.map { $0.item }
        }
    }
    
    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id, imageURL: image, description: description, location: location)
        }
    }
    
    private static let OK_200 = 200
    
    static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(.invalidData)
        }
        return .success(root.feed)
    }
}
