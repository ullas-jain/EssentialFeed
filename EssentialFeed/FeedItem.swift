//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Jain Ullas on 4/1/23.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let imageURL: URL
    let description: String?
    let location: String?
}
