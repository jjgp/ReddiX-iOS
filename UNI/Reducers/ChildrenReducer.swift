//
//  ChildrenReducer.swift
//  UNI
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwift

public func childrenReducer(action: Action, state: ChildrenState?) -> ChildrenState {
    var state = state ?? ChildrenState()
    
    guard let action = action as? ChildrenActions else {
        return state
    }

    switch action {
    case .appendChildren(let children):
        state.children.append(children)
    case .clearChildren:
        state.children = []
    case .isErrored(let isErrored):
        state.isErrored = isErrored
    case .isFetching(let isFetching):
        if isFetching {
            state.isErrored = false
        }
        state.isFetching = isFetching
    case .setSubreddit(let subreddit):
        state.subreddit = subreddit
    }

    return state
}