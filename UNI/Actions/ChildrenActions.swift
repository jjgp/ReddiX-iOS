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
    case isFetching(Bool)
    case isErrored(Bool)
    case replaceChildren(Children)
    case setSubreddit(String)
    
}

public struct FetchChildren: AsyncAction {
    
    let replacement: Bool
    
    public init(replacement: Bool = false) {
        self.replacement = replacement
    }
    
    func run(dispatch: @escaping DispatchFunction, getState: @escaping () -> AppState?) {
        dispatch(ChildrenActions.isFetching(true))
        
        let state = getState()
        
        var parameters: Parameters = ["count": "25"]
        if !replacement,
            let after = state?
                .children
                .children
                .last?
                .after {
            parameters["after"] = after
        }
        
        var URLPath: String = "/.json"
        if let subreddit = state?
            .children
            .subreddit {
            URLPath = "/r/\(subreddit)/\(URLPath)"
        }
        
        let request = Request<Children>(parameters: parameters, URLPath: URLPath)
        RAPI().process(request) { children, response, error in
            if error != nil {
                dispatch(ChildrenActions.isErrored(true))
            } else if let children = children {
                if self.replacement {
                    dispatch(ChildrenActions.replaceChildren(children))
                } else {
                    dispatch(ChildrenActions.appendChildren(children))
                }
            }
            dispatch(ChildrenActions.isFetching(false))
        }
    }
    
}
