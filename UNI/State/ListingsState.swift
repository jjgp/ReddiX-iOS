//
//  ListingsState.swift
//  UNI
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import RAPI
import ReSwift

public struct ListingsState: StateType {
    
    public var after: String?
    public var children = [Child]()
    public var isErrored = false
    public var isFetching = false
    public var subreddit: String?
    
    public init() {}
    
}

extension ListingsState: Equatable {
    
    public static func ==(lhs: ListingsState, rhs: ListingsState) -> Bool {
        return lhs.after == rhs.after &&
            lhs.children == rhs.children &&
            lhs.isErrored == rhs.isErrored &&
            lhs.isFetching == rhs.isFetching &&
            lhs.subreddit == rhs.subreddit
    }
    
}
