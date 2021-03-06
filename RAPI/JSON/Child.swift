//
//  Child.swift
//  RAPI
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import Foundation

public struct Child: Decodable {
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case subreddit
        case title
        case thumbnail
        case url
        
    }
    
    enum T3CodingKeys: String, CodingKey {
        
        case data
        
    }
    
    public let id: String
    public let subreddit: String
    public let title: String
    public let thumbnail: String
    public let url: String
    
}

extension Child {
    
    public init(from decoder: Decoder) throws {
        let t3Container = try decoder.container(keyedBy: T3CodingKeys.self)
        let container = try t3Container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        id = try container.decode(String.self, forKey: .id)
        subreddit = try container.decode(String.self, forKey: .subreddit)
        title = try container.decode(String.self, forKey: .title)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        url = try container.decode(String.self, forKey: .url)
    }
    
}

extension Child: Equatable {
    
    public static func ==(lhs: Child, rhs: Child) -> Bool {
        return lhs.id == rhs.id &&
            lhs.subreddit == rhs.subreddit &&
            lhs.title == rhs.title &&
            lhs.thumbnail == rhs.thumbnail &&
            lhs.url == rhs.url
    }
    
}
