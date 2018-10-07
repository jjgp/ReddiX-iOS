//
//  ListingsActions.swift
//  UNI
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import RAPI
import ReSwift

public enum ListingsActions: Action {
    
    public typealias ListingIndex = Int
    
    case appendChildren(Children, ListingIndex)
    case clearChildren(ListingIndex)
    case isErrored(Bool, ListingIndex)
    case isFetching(Bool, ListingIndex)
    case pushListing()
    case popListing()
    case replaceChildren(Children, ListingIndex)
    case setSubreddit(String?, ListingIndex)
    
}

// MARK:- Equatable

extension ListingsActions: Equatable {
    
    public static func ==(lhs: ListingsActions, rhs: ListingsActions) -> Bool {
        switch (lhs, rhs) {
        case (let .appendChildren(lhsChildren, lhsListingIndex), let .appendChildren(rhsChildren, rhsListingIndex)):
            return lhsChildren == rhsChildren && lhsListingIndex == rhsListingIndex
        case (let .clearChildren(lhsListingIndex), let .clearChildren(rhsListingIndex)):
            return lhsListingIndex == rhsListingIndex
        case (let .isErrored(lhsIsErrored, lhsListingIndex), let .isErrored(rhsIsErrored, rhsListingIndex)):
            return lhsIsErrored == rhsIsErrored && lhsListingIndex == rhsListingIndex
        case (let .isFetching(lhsIsFetching, lhsListingIndex), let .isFetching(rhsIsFetching, rhsListingIndex)):
            return lhsIsFetching == rhsIsFetching && lhsListingIndex == rhsListingIndex
        case (.pushListing, .pushListing):
            return true
        case (.popListing, .popListing):
            return true
        case (let .replaceChildren(lhsChildren, lhsListingIndex), let .replaceChildren(rhsChildren, rhsListingIndex)):
            return lhsChildren == rhsChildren && lhsListingIndex == rhsListingIndex
        case (let .setSubreddit(lhsSubreddit, lhsListingIndex), let .setSubreddit(rhsSubreddit, rhsListingIndex)):
            return lhsSubreddit == rhsSubreddit && lhsListingIndex == rhsListingIndex
        default:
            return false
        }
    }
    
}

// MARK:- Action Creators

extension ListingsActions {
    
    public static func clearChildren() -> Store<AppState>.ActionCreator {
        return { state, store in
            return ListingsActions.clearChildren(state.listings.endIndex - 1)
        }
    }
    
    public static func fetchChildren(replacement: Bool = false) -> Store<AppState>.ActionCreator {
        return { state, store in
            let endIndex = state.listings.endIndex - 1
            guard endIndex >= 0 else {
                fatalError("attempting to fetch children with out of bounds index")
            }
            
            let listing = state.listings[endIndex]
            
            if !replacement, listing.children.count > 0, listing.after == nil {
                return nil
            }
            
            var parameters: Parameters = ["count": "25"]
            if !replacement, let after = listing.after {
                parameters["after"] = after
            }
            
            var URLPath: String = "/.json"
            if let subreddit = listing.subreddit {
                URLPath = "/r/\(subreddit)/\(URLPath)"
            }
            
            store.dispatch(ListingsActions.isFetching(true, endIndex))
            
            let request = Request<Children>(parameters: parameters, URLPath: URLPath)
            RAPI().process(request) { children, response, error in
                if let children = children {
                    let action = replacement ?
                        ListingsActions.replaceChildren(children, endIndex) :
                        ListingsActions.appendChildren(children, endIndex)
                    store.dispatch(action)
                } else {
                    store.dispatch(ListingsActions.isErrored(true, endIndex))
                }
                store.dispatch(ListingsActions.isFetching(false, endIndex))
            }
            
            return nil
        }
    }
    
    public static func setSubreddit(_ subreddit: String) -> Store<AppState>.ActionCreator {
        return { state, store in
            return ListingsActions.setSubreddit(subreddit, state.listings.endIndex - 1)
        }
    }
    
}


