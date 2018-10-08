//
//  ListingsReducer.swift
//  UNI
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwift

public func listingsReducer(action: Action, state: [ListingsState]?) -> [ListingsState] {
    var state = state ?? []
    
    guard let action = action as? ListingsActions else {
        return state
    }

    switch action {
    case .appendChildren(let children, let index):
        guard index < state.count else {
            return state
        }
        
        state[index].children.append(contentsOf: children.children)
        state[index].after = children.after
    case .clearChildren(let index):
        guard index < state.count else {
            return state
        }
        
        state[index].children = []
    case .isErrored(let isErrored, let index):
        guard index < state.count else {
            return state
        }
        
        state[index].isErrored = isErrored
    case .isFetching(let isFetching, let index):
        guard index < state.count else {
            return state
        }
        
        state[index].isFetching = isFetching
    case .pushListing:
        state.append(ListingsState())
        break
    case .popListing:
        _ = state.popLast()
        break
    case .replaceChildren(let children, let index):
        guard index < state.count else {
            return state
        }
        
        state[index].children = children.children
        state[index].after = children.after
    case .setSubreddit(let subreddit, let index):
        guard index < state.count else {
            return state
        }
        
        state[index].subreddit = subreddit
    }

    return state
}
