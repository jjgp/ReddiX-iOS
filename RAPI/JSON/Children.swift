//
//  Children.swift
//  RAPI
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import Foundation

public struct Children: JSON {
    
    enum CodingKeys: String, CodingKey {
        
        case after
        case before
        case children
        
    }
    
    enum ListingCodingKeys: String, CodingKey {
        
        case data
        
    }
    
    let after: String?
    let before: String?
    let children: [Posting]
    
}

extension Children {
    
    public init(from decoder: Decoder) throws {
        let listingContainer = try decoder.container(keyedBy: ListingCodingKeys.self)
        let container = try listingContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        after = try container.decodeIfPresent(String.self, forKey: .after)
        before = try container.decodeIfPresent(String.self, forKey: .before)
        children = try container.decode([Posting].self, forKey: .children)
    }
    
}
