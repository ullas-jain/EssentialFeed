//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Jain Ullas on 4/2/23.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
