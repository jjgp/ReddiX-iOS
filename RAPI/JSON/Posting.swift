//
//  Posting.swift
//  RAPI
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import Foundation

public struct Posting: Decodable {
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case subreddit
        case title
        case url
        
    }
    
    enum T3CodingKeys: String, CodingKey {
        
        case data
        
    }
    
    let id: String
    let subreddit: String
    let title: String
    let url: String
    
}

extension Posting {
    
    public init(from decoder: Decoder) throws {
        let t3Container = try decoder.container(keyedBy: T3CodingKeys.self)
        let container = try t3Container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        id = try container.decode(String.self, forKey: .id)
        subreddit = try container.decode(String.self, forKey: .subreddit)
        title = try container.decode(String.self, forKey: .title)
        url = try container.decode(String.self, forKey: .url)
    }
    
}
