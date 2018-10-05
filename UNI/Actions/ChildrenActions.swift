//
//  ChildrenActions.swift
//  UNI
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import RAPI
import ReSwift

public enum ChildrenActions: Action {
    
    case appendChildren(Children)
    case clearChildren
    case isErrored(Bool)
    case isFetching(Bool)
    case replaceChildren(Children)
    case setSubreddit(String?)
    
}

extension ChildrenActions: Equatable {
    
    public static func ==(lhs: ChildrenActions, rhs: ChildrenActions) -> Bool {
        switch (lhs, rhs) {
        case (let .appendChildren(lhsChildren), let .appendChildren(rhsChildren)):
            return lhsChildren == rhsChildren
        case (.clearChildren, .clearChildren):
            return true
        case (let .isErrored(lhsIsErrored), let .isErrored(rhsIsErrored)):
            return lhsIsErrored == rhsIsErrored
        case (let .isFetching(lhsIsFetching), let .isFetching(rhsIsFetching)):
            return lhsIsFetching == rhsIsFetching
        case (let .replaceChildren(lhsChildren), let .replaceChildren(rhsChildren)):
            return lhsChildren == rhsChildren
        case (let .setSubreddit(lhsSubreddit), let .setSubreddit(rhsSubreddit)):
            return lhsSubreddit == rhsSubreddit
        default:
            return false
        }
    }
    
}

public func fetchChildren(replacement: Bool = false) -> Store<AppState>.ActionCreator {
    return { state, store in
        store.dispatch(ChildrenActions.isFetching(true))
        
        var parameters: Parameters = ["count": "25"]
        if !replacement,
            let after = state
                .children
                .children
                .last?
                .after {
            parameters["after"] = after
        }
        
        var URLPath: String = "/.json"
        if let subreddit = state
            .children
            .subreddit {
            URLPath = "/r/\(subreddit)/\(URLPath)"
        }
        
        let request = Request<Children>(parameters: parameters, URLPath: URLPath)
        RAPI().process(request) { children, response, error in
            if let children = children {
                let action = replacement ?
                    ChildrenActions.replaceChildren(children) :
                    ChildrenActions.appendChildren(children)
                store.dispatch(action)
            } else {
                store.dispatch(ChildrenActions.isErrored(true))
            }
            store.dispatch(ChildrenActions.isFetching(false))
        }
        
        return nil
    }
}
